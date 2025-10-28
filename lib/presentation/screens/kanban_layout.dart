import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanban_assignment/core/constants/context_extensions.dart';
import 'package:kanban_assignment/core/l10n/locale_keys.g.dart';

import '../../domain/entities/task_entity.dart';
import '../providers/presentation_providers.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/task_card.dart';
import 'connectivity_listener.dart';

class KanbanScreen extends ConsumerWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(kanbanStateNotifierProvider);
    final currentLocale = context.locale;

    return ConnectivityListener(
      child: Scaffold(
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
                await ref.read(authStateNotifierProvider.notifier).logout();
              },
              icon: Icon(
                Icons.logout,
                color: context.theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: context.theme.colorScheme.primaryContainer,
          onPressed: () async {
            showModalBottomSheet(
              constraints: BoxConstraints(maxWidth: double.infinity),
              context: context,
              builder: (context) {
                return const _BottomSheetContent();
              },
            );
          },
          child: Icon(
            Icons.add,
            color: context.theme.colorScheme.onPrimaryContainer,
          ),
        ),
        body: SafeArea(
          child: taskState.when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
            data: (tasks) => RefreshIndicator.adaptive(
              backgroundColor: context.theme.colorScheme.primary,
              onRefresh: () async {
                ref.invalidate(kanbanStateNotifierProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: _KanbanColumns(tasks: tasks),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KanbanColumns extends ConsumerStatefulWidget {
  final List<TaskEntity> tasks;
  const _KanbanColumns({required this.tasks});

  @override
  ConsumerState<_KanbanColumns> createState() => __KanbanColumnsState();
}

class __KanbanColumnsState extends ConsumerState<_KanbanColumns> {
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll(Offset globalPosition) {
    // Convert drag position to local coordinates of this widget
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(globalPosition);
    final width = box.size.width;

    const edgeThreshold = 80.0; // px from edge
    const scrollSpeed = 15.0; // px per tick

    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_scrollController.hasClients) return;
      if (local.dx < edgeThreshold) {
        // Scroll left
        _scrollController.jumpTo(
          (_scrollController.offset - scrollSpeed).clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ),
        );
      } else if (local.dx > width - edgeThreshold) {
        // Scroll right
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
              _buildColumn(context, ref, LocaleKeys.todo.tr(), 'todo', todo),
              _buildColumn(
                context,
                ref,
                LocaleKeys.inProgress.tr(),
                'inProgress',
                inProgress,
              ),
              _buildColumn(
                context,
                ref,
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
    WidgetRef ref,
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
          ref
              .read(kanbanStateNotifierProvider.notifier)
              .moveTask
              .call(details.data, status);
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
                    child: ListView(
                      children: items
                          .map(
                            (task) => Draggable<TaskEntity>(
                              data: task,
                              feedback: Material(
                                color: Colors.transparent,
                                child: TaskCard(task: task),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.4,
                                child: TaskCard(task: task),
                              ),
                              child: TaskCard(task: task),
                            ),
                          )
                          .toList(),
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

class _BottomSheetContent extends ConsumerStatefulWidget {
  const _BottomSheetContent();

  @override
  ConsumerState<_BottomSheetContent> createState() =>
      __BottomSheetContentState();
}

class __BottomSheetContentState extends ConsumerState<_BottomSheetContent> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  void _addTask() async {
    final task = TaskEntity(
      id: '',
      title: _titleCtrl.text,
      description: _descCtrl.text,
      status: 'todo',
    );
    await ref.read(kanbanStateNotifierProvider.notifier).createTask(task);
    if (mounted) GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
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
              // labelText: 'Title',
              hintText: LocaleKeys.enterTitle.tr(),
            ),
            AppTextField(
              controller: _descCtrl,
              maxLines: 3,
              // labelText: 'Description',
              hintText: LocaleKeys.enterDescription.tr(),
            ),
            SizedBox(height: 20),
            AppButton(text: LocaleKeys.addTask.tr(), onPressed: _addTask),
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
