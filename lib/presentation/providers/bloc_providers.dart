import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection_container.dart';
import '../../domain/usecases/auth_usecases/get_current_user_usecase.dart';
import '../../domain/usecases/auth_usecases/login_user_usecase.dart';
import '../../domain/usecases/auth_usecases/logout_user_usecase.dart';
import '../../domain/usecases/auth_usecases/register_user_usecase.dart';
import '../../domain/usecases/task_usecases/add_task_usecase.dart';
import '../../domain/usecases/task_usecases/delete_task_usecase.dart';
import '../../domain/usecases/task_usecases/get_task_usecase.dart';
import '../../domain/usecases/task_usecases/update_task_usecase.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/tasks/task_bloc.dart';

final blocProviders = [
  BlocProvider(
    create: (context) => TaskBloc(
      locator<AddTaskUseCase>(),
      locator<DeleteTaskUseCase>(),
      locator<GetTaskUseCase>(),
      locator<UpdateTaskUseCase>(),
    ),
  ),
  BlocProvider(
    create: (context) => AuthBloc(
      locator<GetCurrentUserUseCase>(),
      locator<LoginUserUseCase>(),
      locator<LogoutUserUseCase>(),
      locator<RegisterUserUseCase>(),
    ),
  ),
];
