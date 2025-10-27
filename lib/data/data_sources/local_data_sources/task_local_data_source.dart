import 'package:hive/hive.dart';

import '../../models/task_model.dart';

class TaskLocalDataSource {
  static const _boxName = 'tasksBox';
  late final Box<TaskModel> _box;

  TaskLocalDataSource() {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box<TaskModel>(_boxName);
      print('Hive box $_boxName opened successfully.');
    } else {
      throw Exception('Hive box $_boxName not opened.');
    }
  }

  TaskLocalDataSource._(this._box);

  Future<void> cacheTasks(List<TaskModel> tasks) async {
    await _box.clear();
    await _box.addAll(tasks);
  }

  Future<void> addTask(TaskModel task) async {
    await _box.add(task);
  }

  Future<void> updateTask(TaskModel task) async {
    final index = _box.values.toList().indexWhere((t) => t.id == task.id);
    if (index != -1) {
      await _box.putAt(index, task);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final index = _box.values.toList().indexWhere((t) => t.id == taskId);
    if (index != -1) {
      await _box.deleteAt(index);
    }
  }

  Future<List<TaskModel>> getCachedTasks() async {
    return _box.values.toList();
  }

  Future<void> clearCache() async {
    await _box.clear();
  }

  Future<void> close() async {
    await _box.close();
  }
}
