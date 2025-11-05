import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
import 'core/routes/app_router.dart';
import 'core/themes/app_colors.dart';
import 'core/themes/text_theme.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/tasks/task_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito Sans", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiBlocProvider(
      providers: [
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
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // builder: (context, child) {
        //   return InternetWrapper(child: child ?? const SizedBox());
        // },
      ),
    );
  }
}
