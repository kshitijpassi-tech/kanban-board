import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../data/data_sources/local_data_sources/task_local_data_source.dart';
import '../../data/data_sources/remote_data_sources/auth_data_source.dart';
import '../../data/data_sources/remote_data_sources/task_data_source.dart';
import '../../data/repositories_impl/auth_repo_impl.dart';
import '../../data/repositories_impl/task_repo_impl.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/repositories/task_repo.dart';
import '../../domain/usecases/auth_usecases/get_current_user.dart';
import '../../domain/usecases/auth_usecases/is_logged_in.dart';
import '../../domain/usecases/auth_usecases/login_user.dart';
import '../../domain/usecases/auth_usecases/logout_user.dart';
import '../../domain/usecases/auth_usecases/register_user.dart';
import '../../domain/usecases/task_usecases/add_task.dart';
import '../../domain/usecases/task_usecases/delete_task.dart';
import '../../domain/usecases/task_usecases/get_task.dart';
import '../../domain/usecases/task_usecases/update_task.dart';
import '../constants/network_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => NetworkHelper());

  // Firestore
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Data sources
  sl.registerLazySingleton(() => TaskRemoteDataSource(sl()));
  sl.registerLazySingleton(() => TaskLocalDataSource());
  sl.registerLazySingleton(() => AuthDataSource(sl(), sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetTask(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => IsLoggedIn(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
}
