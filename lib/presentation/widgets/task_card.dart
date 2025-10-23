import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanban_assignment/core/constants/context_extensions.dart';
import '../../core/constants/routes_constants.dart';
import '../../domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == 'completed';

    return Card(
      color: context.theme.colorScheme.primaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: context.theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            task.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.theme.colorScheme.onPrimaryContainer,
            ),
          ),
          trailing: Icon(
            Icons.drag_indicator,
            color: context.theme.colorScheme.onPrimaryContainer,
          ),
          onTap: () {
            context.pushNamed(Routes.taskDetailsScreen, extra: task);
          },
        ),
      ),
    );
  }
}
