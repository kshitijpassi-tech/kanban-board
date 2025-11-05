import 'package:get_it/get_it.dart';

import '../../data/data_sources/local_data_sources/task_local_data_source.dart';
import '../../data/data_sources/remote_data_sources/auth_data_source.dart';
import '../../data/data_sources/remote_data_sources/task_data_source.dart';
import '../../data/repositories_impl/auth_repo_impl.dart';
import '../../data/repositories_impl/task_repo_impl.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/repositories/task_repo.dart';
import '../../domain/usecases/auth_usecases/get_current_user_usecase.dart';
import '../../domain/usecases/auth_usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/auth_usecases/login_user_usecase.dart';
import '../../domain/usecases/auth_usecases/logout_user_usecase.dart';
import '../../domain/usecases/auth_usecases/register_user_usecase.dart';
import '../../domain/usecases/task_usecases/add_task_usecase.dart';
import '../../domain/usecases/task_usecases/delete_task_usecase.dart';
import '../../domain/usecases/task_usecases/get_task_usecase.dart';
import '../../domain/usecases/task_usecases/update_task_usecase.dart';
import '../helpers/firebase_helper.dart';
import '../helpers/network_helper.dart';

final locator = GetIt.instance;

Future<void> init() async {
  locator.registerLazySingleton(() => NetworkHelper());

  // Firebase
  locator.registerLazySingleton(() => FirebaseHelper());

  // Data sources
  locator.registerLazySingleton(() => TaskRemoteDataSource(locator()));
  locator.registerLazySingleton(() => TaskLocalDataSource());
  locator.registerLazySingleton(() => AuthDataSource(locator()));

  // Repository
  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(locator(), locator(), locator()),
  );
  locator.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(locator()));

  // Use cases
  locator.registerLazySingleton(() => GetTaskUseCase(locator()));
  locator.registerLazySingleton(() => AddTaskUseCase(locator()));
  locator.registerLazySingleton(() => UpdateTaskUseCase(locator()));
  locator.registerLazySingleton(() => DeleteTaskUseCase(locator()));

  locator.registerLazySingleton(() => GetCurrentUserUseCase(locator()));
  locator.registerLazySingleton(() => IsLoggedInUseCase(locator()));
  locator.registerLazySingleton(() => LoginUserUseCase(locator()));
  locator.registerLazySingleton(() => RegisterUserUseCase(locator()));
  locator.registerLazySingleton(() => LogoutUserUseCase(locator()));
}
