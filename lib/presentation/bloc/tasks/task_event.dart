part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final String userId;
  const LoadTasks(this.userId);
}

class RefreshTasks extends TaskEvent {
  final String userId;
  const RefreshTasks(this.userId);
}

class AddNewTask extends TaskEvent {
  final String userId;
  final TaskEntity task;
  const AddNewTask(this.userId, this.task);
}

class UpdateExistingTask extends TaskEvent {
  final String userId;
  final TaskEntity task;
  final String? status;
  const UpdateExistingTask(this.userId, this.task, this.status);
}

class DeleteExistingTask extends TaskEvent {
  final String userId;
  final String taskId;
  const DeleteExistingTask(this.userId, this.taskId);
}

class _TasksUpdated extends TaskEvent {
  final List<TaskEntity> tasks;

  const _TasksUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class _TasksError extends TaskEvent {
  final String message;

  const _TasksError(this.message);

  @override
  List<Object?> get props => [message];
}
