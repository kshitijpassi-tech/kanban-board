import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_router.dart';
import 'data/models/task_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await init();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasksBox');

  await EasyLocalization.ensureInitialized();

  await AppRouter.setupRoutes();

  if (kDebugMode) {
    HttpOverrides.global = CustomHttpOverrides();
  }

  runApp(
    ProviderScope(
      // observers: [Logger()],
      child: EasyLocalization(
        supportedLocales: [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: const MainApp(),
      ),
    ),
  );
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// final class Logger extends ProviderObserver {
//   @override
//   void didUpdateProvider(
//     ProviderObserverContext context,
//     Object? previousValue,
//     Object? newValue,
//   ) {
//     debugPrint('''
// ------------------------------------------------------------
// ${context.provider.name ?? context.provider.runtimeType}
// ------------------------------------------------------------
//   previousValue: $previousValue
//   newValue: $newValue
// ------------------------------------------------------------''');
//   }
// }
