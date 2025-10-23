import 'package:hive/hive.dart';

import '../../models/task_model.dart';

class TaskLocalDataSource {
  static const _boxName = 'tasksBox';

  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    await box.clear();
    await box.addAll(tasks);
  }

  Future<void> addTask(TaskModel task) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    await box.add(task);
  }

  Future<void> updateTask(TaskModel task) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    final index = box.values.toList().indexWhere((t) => t.id == task.id);
    if (index != -1) {
      await box.putAt(index, task);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    final index = box.values.toList().indexWhere((t) => t.id == taskId);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  Future<List<TaskModel>> getCachedTasks() async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    return box.values.toList();
  }

  Future<void> clearCache() async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    await box.clear();
  }
}
