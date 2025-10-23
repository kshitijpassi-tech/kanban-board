import 'package:flutter/material.dart';

import 'core/themes/app_colors.dart';
import 'core/routes/app_router.dart';
import 'core/themes/text_theme.dart';
import 'presentation/screens/internet_wrapper.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito Sans", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      // builder: (context, child) {
      //   return InternetWrapper(child: child ?? const SizedBox());
      // },
    );
  }
}
