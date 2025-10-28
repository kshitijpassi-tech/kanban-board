import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/data_sources/local_data_sources/task_local_data_source.dart';
import '../../data/data_sources/remote_data_sources/task_data_source.dart';
import '../../data/repositories_impl/task_repo_impl.dart';
import '../../domain/usecases/task_usecases/add_task_usecase.dart';
import '../../domain/usecases/task_usecases/delete_task_usecase.dart';
import '../../domain/usecases/task_usecases/get_task_usecase.dart';
import '../../domain/usecases/task_usecases/update_task_usecase.dart';
import 'helper_providers.dart';

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource(ref.read(firebaseHelperProvider));
});

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSource();
});

final taskRepoImplProvider = Provider<TaskRepositoryImpl>((ref) {
  return TaskRepositoryImpl(
    ref.read(taskRemoteDataSourceProvider),
    ref.read(taskLocalDataSourceProvider),
    ref.read(networkHelperProvider),
  );
});

final addTaskProvider = Provider<AddTaskUseCase>((ref) {
  return AddTaskUseCase(ref.read(taskRepoImplProvider));
});

final deleteTaskProvider = Provider<DeleteTaskUseCase>((ref) {
  return DeleteTaskUseCase(ref.read(taskRepoImplProvider));
});

final getTaskProvider = Provider<GetTaskUseCase>((ref) {
  return GetTaskUseCase(ref.read(taskRepoImplProvider));
});

final updateTaskProvider = Provider<UpdateTaskUseCase>((ref) {
  return UpdateTaskUseCase(ref.read(taskRepoImplProvider));
});
