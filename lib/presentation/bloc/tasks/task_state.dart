part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final DateTime timestamp; // Add timestamp to force state changes

  // Constructor that auto-generates timestamp
  TaskLoaded(this.tasks) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [tasks, timestamp]; // Include timestamp in props
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
