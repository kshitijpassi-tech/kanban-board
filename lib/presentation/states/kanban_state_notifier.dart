import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import '../../core/di/injection_container.dart';

import '../../domain/entities/task_entity.dart';

import '../../domain/usecases/task_usecases/add_task.dart';
import '../../domain/usecases/task_usecases/delete_task.dart';
import '../../domain/usecases/task_usecases/get_task.dart';
import '../../domain/usecases/task_usecases/update_task.dart';

class KanbanNotifier extends StateNotifier<AsyncValue<List<TaskEntity>>> {
  final GetTask getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final String userId;

  KanbanNotifier({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.userId,
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    getTasks(userId).listen(
      (tasks) => state = AsyncValue.data(tasks),
      onError: (e, st) => state = AsyncValue.error(e, st),
    );
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

final kanbanProvider =
    StateNotifierProvider<KanbanNotifier, AsyncValue<List<TaskEntity>>>((ref) {
      final User? user = FirebaseAuth.instance.currentUser;
      return KanbanNotifier(
        getTasks: sl<GetTask>(),
        addTask: sl<AddTask>(),
        updateTask: sl<UpdateTask>(),
        deleteTask: sl<DeleteTask>(),
        userId: user!.uid,
      );
    });
