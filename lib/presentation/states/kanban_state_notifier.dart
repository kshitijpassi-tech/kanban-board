import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/task_usecases/add_task_usecase.dart';
import '../../domain/usecases/task_usecases/delete_task_usecase.dart';
import '../../domain/usecases/task_usecases/get_task_usecase.dart';
import '../../domain/usecases/task_usecases/update_task_usecase.dart';

class KanbanStateNotifier extends StateNotifier<AsyncValue<List<TaskEntity>>> {
  final GetTaskUseCase getTasks;
  final AddTaskUseCase addTask;
  final UpdateTaskUseCase updateTask;
  final DeleteTaskUseCase deleteTask;
  final String userId;

  KanbanStateNotifier({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.userId,
  }) : super(const AsyncValue.loading()) {
    _init();
  }
  StreamSubscription<List<TaskEntity>>? _taskSub;

  void _init() {
    _taskSub = getTasks(userId).listen(
      (tasks) => state = AsyncValue.data(tasks),
      onError: (e, st) => state = AsyncValue.error(e, st),
    );
  }

  @override
  void dispose() {
    _taskSub?.cancel();
    super.dispose();
  }

  Future<void> getTask() async {
    state = const AsyncValue.loading();
    getTasks(userId).listen(
      (tasks) => state = AsyncValue.data(tasks),
      onError: (e, st) => state = AsyncValue.error(e, st),
    );
  }

  Future<void> moveTask(TaskEntity task, String newStatus) async {
    updateTask.call(userId, task.copyWith(status: newStatus));
  }

  Future<void> createTask(TaskEntity task) async {
    await addTask.call(userId, task);
  }

  Future<void> removeTask(TaskEntity task) async {
    await deleteTask.call(userId, task.id);
  }
}
