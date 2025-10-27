import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/task_entity.dart';
import '../../presentation/screens/kanban_layout.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/screens/task_details_screen.dart';
import '../constants/routes_constants.dart';

class AppRouter {
  AppRouter._();

  static late final GoRouter _router;
  static GoRouter get router => _router;

  // static final RouteObserverService _routeObserver = RouteObserverService();

  static Future<void> setupRoutes() async {
    final auth = FirebaseAuth.instance;

    _router = GoRouter(
      debugLogDiagnostics: false,
      routes: _routes,
      initialLocation: Routes.loginScreen,
      redirect: (context, state) {
        final user = auth.currentUser;

        final loggingIn =
            state.matchedLocation == Routes.loginScreen ||
            state.matchedLocation == Routes.registerScreen;

        if (user == null && !loggingIn) return Routes.loginScreen;
        if (user != null && loggingIn) return Routes.kanbanLayout;

        return null;
      },
      refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
    );
  }

  static final List<RouteBase> _routes = [
    // GoRoute(
    //   name: Routes.noInternetScreen,
    //   path: Routes.noInternetScreen,
    //   pageBuilder: (context, state) =>
    //       MaterialPage(key: state.pageKey, child: NoInternetScreen()),
    // ),
    GoRoute(
      name: Routes.loginScreen,
      path: Routes.loginScreen,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: Routes.registerScreen,
      path: Routes.registerScreen,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      name: Routes.kanbanLayout,
      path: Routes.kanbanLayout,
      builder: (context, state) => const KanbanScreen(),
    ),
    GoRoute(
      name: Routes.taskDetailsScreen,
      path: Routes.taskDetailsScreen,
      builder: (context, state) =>
          TaskDetailScreen(task: state.extra as TaskEntity),
    ),
  ];
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
