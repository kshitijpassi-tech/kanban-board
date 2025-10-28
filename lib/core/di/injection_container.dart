// import 'package:get_it/get_it.dart';

// import '../../data/data_sources/local_data_sources/task_local_data_source.dart';
// import '../../data/data_sources/remote_data_sources/auth_data_source.dart';
// import '../../data/data_sources/remote_data_sources/task_data_source.dart';
// import '../../data/repositories_impl/auth_repo_impl.dart';
// import '../../data/repositories_impl/task_repo_impl.dart';
// import '../../domain/repositories/auth_repo.dart';
// import '../../domain/repositories/task_repo.dart';
// import '../../domain/usecases/auth_usecases/get_current_user_usecase.dart';
// import '../../domain/usecases/auth_usecases/is_logged_in_usecase.dart';
// import '../../domain/usecases/auth_usecases/login_user_usecase.dart';
// import '../../domain/usecases/auth_usecases/logout_user_usecase.dart';
// import '../../domain/usecases/auth_usecases/register_user_usecase.dart';
// import '../../domain/usecases/task_usecases/add_task_usecase.dart';
// import '../../domain/usecases/task_usecases/delete_task_usecase.dart';
// import '../../domain/usecases/task_usecases/get_task_usecase.dart';
// import '../../domain/usecases/task_usecases/update_task_usecase.dart';
// import '../constants/network_helper.dart';
// import '../helpers/firebase_helper.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   sl.registerLazySingleton(() => NetworkHelper());

//   // Firebase
//   sl.registerLazySingleton(() => FirebaseHelper());

//   // Data sources
//   sl.registerLazySingleton(() => TaskRemoteDataSource(sl()));
//   sl.registerLazySingleton(() => TaskLocalDataSource());
//   sl.registerLazySingleton(() => AuthDataSource(sl()));

//   // Repository
//   sl.registerLazySingleton<TaskRepository>(
//     () => TaskRepositoryImpl(sl(), sl(), sl()),
//   );
//   sl.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(sl()));

//   // Use cases
//   sl.registerLazySingleton(() => GetTaskUseCase(sl()));
//   sl.registerLazySingleton(() => AddTaskUseCase(sl()));
//   sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
//   sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));

//   sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
//   sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));
//   sl.registerLazySingleton(() => LoginUserUseCase(sl()));
//   sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
//   sl.registerLazySingleton(() => LogoutUserUseCase(sl()));
// }
