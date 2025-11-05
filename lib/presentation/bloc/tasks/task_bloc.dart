import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/task_entity.dart';
import '../../../domain/usecases/task_usecases/add_task_usecase.dart';
import '../../../domain/usecases/task_usecases/delete_task_usecase.dart';
import '../../../domain/usecases/task_usecases/get_task_usecase.dart';
import '../../../domain/usecases/task_usecases/update_task_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTaskUseCase _addTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final GetTaskUseCase _getTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  StreamSubscription<List<TaskEntity>>? _taskSubscription;

  TaskBloc(
    this._addTaskUseCase,
    this._deleteTaskUseCase,
    this._getTaskUseCase,
    this._updateTaskUseCase,
  ) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<_TasksUpdated>(_onTasksUpdated);
    on<_TasksError>(_onTasksError);
    on<RefreshTasks>(_onRefreshTasks);
    on<AddNewTask>(_onAddNewTask);
    on<UpdateExistingTask>(_onUpdateExistingTask);
    on<DeleteExistingTask>(_onDeleteExistingTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    // Cancel existing subscription
    await _taskSubscription?.cancel();

    // Create NEW subscription that adds events to the bloc
    _taskSubscription = _getTaskUseCase(event.userId).listen(
      (tasks) {
        // Create a NEW list to ensure state change detection
        add(_TasksUpdated(List<TaskEntity>.from(tasks)));
      },
      onError: (error, stackTrace) {
        add(_TasksError(error.toString()));
      },
      cancelOnError: false,
    );
  }

  void _onTasksUpdated(_TasksUpdated event, Emitter<TaskState> emit) {
    // Force a new state by creating a new list
    emit(TaskLoaded(List<TaskEntity>.from(event.tasks)));
  }

  void _onTasksError(_TasksError event, Emitter<TaskState> emit) {
    emit(TaskError(event.message));
  }

  Future<void> _onRefreshTasks(
    RefreshTasks event,
    Emitter<TaskState> emit,
  ) async {
    add(LoadTasks(event.userId));
  }

  Future<void> _onAddNewTask(AddNewTask event, Emitter<TaskState> emit) async {
    try {
      await _addTaskUseCase(event.userId, event.task);
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  Future<void> _onUpdateExistingTask(
    UpdateExistingTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _updateTaskUseCase(
        event.userId,
        event.task.copyWith(status: event.status),
      );
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> _onDeleteExistingTask(
    DeleteExistingTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _deleteTaskUseCase(event.userId, event.taskId);
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
