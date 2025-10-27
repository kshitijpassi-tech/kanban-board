import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanban_assignment/core/constants/context_extensions.dart';

import '../../domain/entities/task_entity.dart';
import '../../l10n/locale_keys.g.dart';
import '../states/kanban_state_notifier.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final TaskEntity task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  String _status = 'todo';

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task.title);
    _descCtrl = TextEditingController(text: widget.task.description);
    _status = widget.task.status;
  }

  void _updateTask() async {
    final updated = widget.task.copyWith(
      title: _titleCtrl.text,
      description: _descCtrl.text,
      status: _status,
    );
    await ref
        .read(kanbanStateNotifierProvider.notifier)
        .moveTask(updated, _status);
    if (mounted) GoRouter.of(context).pop();
  }

  void _deleteTask() async {
    await ref
        .read(kanbanStateNotifierProvider.notifier)
        .removeTask(widget.task);
    if (mounted) GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    return GestureDetector(
      onTap: () => context.unFocus(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
        appBar: AppBar(
          title: Text(LocaleKeys.taskDetails.tr()),
          backgroundColor: context.theme.colorScheme.primaryContainer,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet
                  ? 800
                  : double.infinity, // limit width on tablets
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _titleCtrl,
                    hintText: LocaleKeys.enterTitle.tr(),
                    // labelText: 'Title',
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    hintText: LocaleKeys.enterDescription.tr(),
                    // labelText: 'Description',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    alignment: AlignmentGeometry.bottomCenter,

                    items: [
                      DropdownMenuItem(
                        value: 'todo',
                        child: Text(LocaleKeys.todo.tr()),
                      ),
                      DropdownMenuItem(
                        value: 'inProgress',
                        child: Text(LocaleKeys.inProgress.tr()),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text(LocaleKeys.completed.tr()),
                      ),
                    ],
                    onChanged: (v) => setState(() => _status = v!),
                    decoration: InputDecoration(
                      filled: true,

                      labelText: LocaleKeys.taskStatus.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderSide: BorderSide(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: LocaleKeys.updateTask.tr(),
                    onPressed: _updateTask,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: LocaleKeys.delete.tr(),
                    onPressed: () {
                      context
                          .showAlertDialog(
                            title: LocaleKeys.areYouSure.tr(),
                            content: LocaleKeys.confirmDelete.tr(),
                            confirmText: LocaleKeys.delete.tr(),
                            isDestructive: true,
                          )
                          .then((confirmed) {
                            if (confirmed == true) {
                              _deleteTask();
                            }
                          });
                    },
                    outlined: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
