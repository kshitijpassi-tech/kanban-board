// test/presentation/auth/login_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kanban_assignment/core/constants/routes_constants.dart';
import 'package:kanban_assignment/presentation/screens/login_screen.dart';
import 'package:kanban_assignment/presentation/states/auth_state_notifier.dart';
import 'package:kanban_assignment/presentation/widgets/app_button.dart';
import 'package:kanban_assignment/presentation/widgets/app_text_field.dart';
import 'package:mocktail/mocktail.dart';

/// ---------------------------
/// Mocks
/// ---------------------------
class MockAuthNotifier extends Mock implements AuthStateNotifier {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockAuthNotifier mockAuthNotifier;
  late bool navigatedToKanban;
  late bool navigatedToRegister;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockAuthNotifier = MockAuthNotifier();
    navigatedToKanban = false;
    navigatedToRegister = false;
  });

  /// Helper to create a real GoRouter for widget tests
  GoRouter createTestRouter(Widget screen) {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          name: Routes.loginScreen,
          path: '/login',
          builder: (context, state) => screen,
        ),
        GoRoute(
          name: Routes.kanbanLayout,
          path: '/kanban',
          builder: (context, state) {
            navigatedToKanban = true;
            return const Scaffold(body: Text('Kanban Screen'));
          },
        ),
        GoRoute(
          name: Routes.registerScreen,
          path: '/register',
          builder: (context, state) {
            navigatedToRegister = true;
            return const Scaffold(body: Text('Register Screen'));
          },
        ),
      ],
    );
  }

  Widget createTestWidget() {
    final router = createTestRouter(
      ProviderScope(
        overrides: [
          authStateNotifierProvider.overrideWith((ref) => mockAuthNotifier),
        ],
        child: const LoginScreen(),
      ),
    );

    return MaterialApp.router(routerConfig: router);
  }

  /// ---------------------------
  /// Tests
  /// ---------------------------
  group('LoginScreen Widget Tests', () {
    testWidgets('renders fields and buttons', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text("Don't have an account? Register"), findsOneWidget);
    });

    testWidgets('shows validation errors on empty fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.textContaining('required'), findsWidgets);
    });

    testWidgets('successful login navigates to KanbanLayout', (tester) async {
      when(
        () => mockAuthNotifier.login(any(), any()),
      ).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(AppTextField).first, 'test@a.com');
      await tester.enterText(find.byType(AppTextField).last, 'password123');
      await tester.tap(find.text('Login'));

      // Wait for async and rebuilds
      await tester.runAsync(() async {
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      });

      verify(
        () => mockAuthNotifier.login('test@a.com', 'password123'),
      ).called(1);
      expect(navigatedToKanban, isTrue);
    });

    testWidgets('shows error snackbar on failed login', (tester) async {
      when(
        () => mockAuthNotifier.login(any(), any()),
      ).thenThrow(Exception('Invalid credentials'));

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(AppTextField).first, 'test@a.com');
      await tester.enterText(find.byType(AppTextField).last, 'wrongpass');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Login failed'), findsOneWidget);
    });

    testWidgets('navigates to Register screen on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text("Don't have an account? Register"));
      await tester.pumpAndSettle();

      expect(navigatedToRegister, isTrue);
    });

    testWidgets('shows loading overlay during login', (tester) async {
      when(() => mockAuthNotifier.login(any(), any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 200));
        return;
      });

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(AppTextField).first, 'test@a.com');
      await tester.enterText(find.byType(AppTextField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Expect loading indicator
      expect(find.byType(Center), findsWidgets);

      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 300));
      });

      await tester.pumpAndSettle();
    });
  });
}
