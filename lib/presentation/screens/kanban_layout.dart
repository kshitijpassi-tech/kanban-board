import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanban_assignment/core/constants/context_extensions.dart';
import 'package:kanban_assignment/presentation/widgets/app_text_field.dart';

import '../../domain/entities/task_entity.dart';
import '../states/auth_state_notifier.dart';
import '../states/kanban_state_notifier.dart';
import '../widgets/app_button.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/task_card.dart';
import 'connectivity_listener.dart';

class KanbanScreen extends ConsumerWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(kanbanProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return ConnectivityListener(
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: context.theme.colorScheme.primaryContainer,
          actions: [
            IconButton(
              tooltip: 'Logout',
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
              constraints: BoxConstraints(
                maxWidth: double.infinity, // limit width on tablets
              ),
              context: context,
              builder: (context) {
                return const BottomSheetContent();
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
              onRefresh: () async {
                ref.invalidate(kanbanProvider);
              },
              child: tasks.isEmpty
                  ? const Center(child: Text("No tasks available"))
                  : KanbanColumns(tasks: tasks),
            ),
          ),
        ),
      ),
    );
  }
}

class KanbanColumns extends ConsumerStatefulWidget {
  final List<TaskEntity> tasks;
  const KanbanColumns({super.key, required this.tasks});

  @override
  ConsumerState<KanbanColumns> createState() => _KanbanColumnsState();
}

class _KanbanColumnsState extends ConsumerState<KanbanColumns> {
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
              _buildColumn(context, ref, 'To Do', 'todo', todo),
              _buildColumn(
                context,
                ref,
                'In Progress',
                'inProgress',
                inProgress,
              ),
              _buildColumn(context, ref, 'Completed', 'completed', completed),
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
          ref.read(kanbanProvider.notifier).moveTask.call(details.data, status);
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

class BottomSheetContent extends ConsumerStatefulWidget {
  const BottomSheetContent({super.key});

  @override
  ConsumerState<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends ConsumerState<BottomSheetContent> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  void _addTask() async {
    final task = TaskEntity(
      id: '',
      title: _titleCtrl.text,
      description: _descCtrl.text,
      status: 'todo',
    );
    await ref.read(kanbanProvider.notifier).createTask(task);
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
              'Add New Task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            AppTextField(
              controller: _titleCtrl,
              // labelText: 'Title',
              hintText: 'Title',
            ),
            AppTextField(
              controller: _descCtrl,
              maxLines: 3,
              // labelText: 'Description',
              hintText: 'Description',
            ),
            SizedBox(height: 20),
            AppButton(text: "Add", onPressed: _addTask),
            AppButton(
              text: "Cancel",
              onPressed: () => context.pop(),
              outlined: true,
            ),
          ],
        ),
      ),
    );
  }
}
