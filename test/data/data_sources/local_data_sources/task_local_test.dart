import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:kanban_assignment/data/data_sources/local_data_sources/task_local_data_source.dart';
import 'package:kanban_assignment/data/models/task_model.dart';

void main() {
  late TaskLocalDataSource dataSource;

  setUpAll(() async {
    await setUpTestHive();

    // ✅ Register adapter only once
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  setUp(() {
    dataSource = TaskLocalDataSource();
  });

  test('addTask() should add a single task', () async {
    final task = TaskModel(
      id: '1',
      title: 'Test Task',
      description: 'Desc',
      status: 'todo',
    );

    await dataSource.addTask(task);
    final tasks = await dataSource.getCachedTasks();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Test Task');
  });

  test('updateTask() should update existing task', () async {
    final task = TaskModel(
      id: '1',
      title: 'Old',
      description: 'Desc',
      status: 'todo',
    );
    await dataSource.addTask(task);

    final updatedTask = TaskModel(
      id: '1',
      title: 'Updated',
      description: 'Desc',
      status: 'completed',
    );
    await dataSource.updateTask(updatedTask);

    final tasks = await dataSource.getCachedTasks();
    expect(tasks.first.title, 'Updated');
    expect(tasks.first.status, 'completed');
  });

  test('updateTask() should do nothing if not found', () async {
    final task = TaskModel(
      id: '999',
      title: 'Unknown',
      description: '',
      status: 'todo',
    );
    await dataSource.updateTask(task);

    final tasks = await dataSource.getCachedTasks();
    expect(tasks.isEmpty, true);
  });

  test('deleteTask() should delete existing task', () async {
    final task = TaskModel(
      id: '1',
      title: 'Delete Me',
      description: '',
      status: 'todo',
    );
    await dataSource.addTask(task);
    await dataSource.deleteTask('1');

    final tasks = await dataSource.getCachedTasks();
    expect(tasks.isEmpty, true);
  });

  test('deleteTask() should do nothing if id not found', () async {
    final task = TaskModel(
      id: '1',
      title: 'Keep Me',
      description: '',
      status: 'todo',
    );
    await dataSource.addTask(task);
    await dataSource.deleteTask('999');

    final tasks = await dataSource.getCachedTasks();
    expect(tasks.length, 1);
  });

  test('getCachedTasks() should return tasks list', () async {
    final task1 = TaskModel(
      id: '1',
      title: 'T1',
      description: '',
      status: 'todo',
    );
    final task2 = TaskModel(
      id: '2',
      title: 'T2',
      description: '',
      status: 'completed',
    );

    await dataSource.cacheTasks([task1, task2]);
    final tasks = await dataSource.getCachedTasks();

    expect(tasks.length, 2);
  });

  test('clearCache() should clear all tasks', () async {
    final task = TaskModel(
      id: '1',
      title: 'T1',
      description: '',
      status: 'todo',
    );
    await dataSource.addTask(task);

    await dataSource.clearCache();
    final tasks = await dataSource.getCachedTasks();

    expect(tasks.isEmpty, true);
  });
}
