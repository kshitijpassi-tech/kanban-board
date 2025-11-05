import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/context_extensions.dart';
import '../../core/helpers/firebase_helper.dart';
import '../../core/l10n/locale_keys.g.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/tasks/task_bloc.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/task_card.dart';

class KanbanScreen extends StatelessWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    context.read<TaskBloc>().add(LoadTasks(FirebaseHelper().currentUserId!));
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.primaryContainer,
        leading: IconButton(
          onPressed: () {
            if (currentLocale.languageCode == 'en') {
              context.setLocale(const Locale('hi', 'IN'));
            } else {
              context.setLocale(const Locale('en', 'US'));
            }
          },
          icon: Icon(Icons.language),
        ),
        actions: [
          IconButton(
            tooltip: LocaleKeys.logout.tr(),
            onPressed: () async {
              context.read<AuthBloc>().add(LogoutEvent());
            },
            icon: Icon(
              Icons.logout,
              color: context.theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            // Optional: Handle errors with snackbar
            if (state is TaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is TaskLoading) {
              return const LoadingIndicator();
            }

            if (state is TaskLoaded) {
              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  final completer = Completer();
                  context.read<TaskBloc>().add(
                    RefreshTasks(FirebaseHelper().currentUserId ?? ''),
                  );
                  // Wait a bit for the refresh
                  await Future.delayed(const Duration(milliseconds: 500));
                  completer.complete();
                  return completer.future;
                },
                child: _KanbanColumns(tasks: state.tasks),
              );
            }

            if (state is TaskError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TaskBloc>().add(
                          LoadTasks(FirebaseHelper().currentUserId!),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.theme.colorScheme.primaryContainer,
        onPressed: () async {
          showModalBottomSheet(
            constraints: BoxConstraints(maxWidth: double.infinity),
            context: context,
            isScrollControlled: true,
            builder: (modalContext) {
              // Pass the bloc context to the modal
              return BlocProvider.value(
                value: context.read<TaskBloc>(),
                child: _BottomSheetContent(),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: context.theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _KanbanColumns extends StatefulWidget {
  final List<TaskEntity> tasks;
  const _KanbanColumns({required this.tasks});

  @override
  State<_KanbanColumns> createState() => __KanbanColumnsState();
}

class __KanbanColumnsState extends State<_KanbanColumns> {
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(globalPosition);
    final width = box.size.width;

    const edgeThreshold = 80.0;
    const scrollSpeed = 15.0;

    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_scrollController.hasClients) return;
      if (local.dx < edgeThreshold) {
        _scrollController.jumpTo(
          (_scrollController.offset - scrollSpeed).clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ),
        );
      } else if (local.dx > width - edgeThreshold) {
        _scrollController.jumpTo(
          (_scrollController.offset + scrollSpeed).clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ),
        );
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;
    final todo = tasks.where((t) => t.status == 'todo').toList();
    final inProgress = tasks.where((t) => t.status == 'inProgress').toList();
    final completed = tasks.where((t) => t.status == 'completed').toList();

    return Listener(
      onPointerMove: (event) => _startAutoScroll(event.position),
      onPointerUp: (_) => _stopAutoScroll(),
      child: Center(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumn(context, LocaleKeys.todo.tr(), 'todo', todo),
              _buildColumn(
                context,
                LocaleKeys.inProgress.tr(),
                'inProgress',
                inProgress,
              ),
              _buildColumn(
                context,
                LocaleKeys.completed.tr(),
                'completed',
                completed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context,
    String title,
    String status,
    List<TaskEntity> items,
  ) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    return Container(
      width: isTablet ? 400 : 250,
      margin: const EdgeInsets.all(8),
      child: DragTarget<TaskEntity>(
        onAcceptWithDetails: (details) {
          context.read<TaskBloc>().add(
            UpdateExistingTask(
              FirebaseHelper().currentUserId ?? '',
              details.data,
              status,
            ),
          );
        },
        builder: (context, candidateData, rejectedData) {
          return Card(
            color: context.theme.cardColor,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    title,
                    style: context.theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final task = items[index];
                        return Draggable<TaskEntity>(
                          data: task,
                          feedback: Material(
                            color: Colors.transparent,
                            child: SizedBox(
                              width: isTablet ? 400 : 250,
                              child: TaskCard(task: task),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.4,
                            child: TaskCard(task: task),
                          ),
                          child: TaskCard(task: task),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomSheetContent extends StatefulWidget {
  const _BottomSheetContent();

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        ),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.addNewTask.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            AppTextField(
              controller: _titleCtrl,
              hintText: LocaleKeys.enterTitle.tr(),
            ),
            AppTextField(
              controller: _descCtrl,
              maxLines: 3,
              hintText: LocaleKeys.enterDescription.tr(),
            ),
            SizedBox(height: 20),
            AppButton(
              text: LocaleKeys.addTask.tr(),
              onPressed: () {
                if (_titleCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a title')),
                  );
                  return;
                }

                final task = TaskEntity(
                  id: '', // Firestore will generate this
                  title: _titleCtrl.text.trim(),
                  description: _descCtrl.text.trim(),
                  status: 'todo',
                );

                context.read<TaskBloc>().add(
                  AddNewTask(FirebaseHelper().currentUserId ?? '', task),
                );

                // Close the bottom sheet
                context.pop();
              },
            ),
            AppButton(
              text: LocaleKeys.cancel.tr(),
              onPressed: () => context.pop(),
              outlined: true,
            ),
          ],
        ),
      ),
    );
  }
}
