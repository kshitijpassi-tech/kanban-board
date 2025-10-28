import 'package:kanban_assignment/data/data_sources/local_data_sources/task_local_data_source.dart';

import '../../core/errors/exceptions.dart';
import '../../core/helpers/network_helper.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repo.dart';
import '../data_sources/remote_data_sources/task_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _taskRemoteDataSource;
  final TaskLocalDataSource _taskLocalDataSource;
  final NetworkHelper _networkHelper;

  TaskRepositoryImpl(
    this._taskRemoteDataSource,
    this._taskLocalDataSource,
    this._networkHelper,
  );

  @override
  Stream<List<TaskEntity>> getTasks(String userId) async* {
    try {
      // final hasInternet = await NetworkHelper.hasInternet();
      final hasInternet = await _networkHelper.hasInternet();
      if (!hasInternet) {
        // offline - return cached tasks
        final cachedTasks = await _taskLocalDataSource.getCachedTasks();
        if (cachedTasks.isEmpty) {
          throw CacheException("No cached tasks available.");
        }
        yield cachedTasks.map((t) => t.toEntity()).toList();
      } else {
        // online - fetch from Firestore
        await for (final remoteTasks in _taskRemoteDataSource.getTasks(
          userId,
        )) {
          // cache tasks locally
          await _taskLocalDataSource.cacheTasks(remoteTasks);
          yield remoteTasks.map((t) => t.toEntity()).toList();
        }
      }
    } on CacheException catch (e) {
      throw CacheException(e.message);
    } on NetworkException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addTask(String userId, TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _taskLocalDataSource.addTask(model);
    try {
      await _taskRemoteDataSource.addTask(userId, model);
    } on CacheException catch (e) {
      throw CacheException(e.message);
    } on NetworkException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateTask(String userId, TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _taskLocalDataSource.updateTask(model);
    try {
      await _taskRemoteDataSource.updateTask(userId, model);
    } on CacheException catch (e) {
      throw CacheException(e.message);
    } on NetworkException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    await _taskLocalDataSource.deleteTask(taskId);
    try {
      await _taskRemoteDataSource.deleteTask(userId, taskId);
    } on CacheException catch (e) {
      throw CacheException(e.message);
    } on NetworkException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
