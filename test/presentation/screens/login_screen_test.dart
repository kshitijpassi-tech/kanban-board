import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanban_assignment/domain/entities/task_entity.dart';
import 'package:kanban_assignment/presentation/screens/kanban_layout.dart';
import 'package:kanban_assignment/presentation/states/auth_state_notifier.dart';
import 'package:kanban_assignment/presentation/states/kanban_state_notifier.dart';
import 'package:kanban_assignment/presentation/widgets/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';

/// --- Mock Classes ---
class MockKanbanNotifier extends Mock implements KanbanStateNotifier {}

class MockAuthNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late MockKanbanNotifier mockKanbanNotifier;
  late MockAuthNotifier mockAuthNotifier;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockKanbanNotifier = MockKanbanNotifier();
    mockAuthNotifier = MockAuthNotifier();

    when(() => mockKanbanNotifier.state).thenReturn(const AsyncValue.loading());

    when(
      () => mockKanbanNotifier.addListener(
        any(),
      ),
    ).thenAnswer((_) => () {});
    // mockKanbanNotifier.removeListener does not exist on the notifier, so no mock for it
    when(() => mockKanbanNotifier.dispose()).thenReturn(null);
  });

  Widget createTestApp(Widget child) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => child),
      ],
    );

    return ProviderScope(
      overrides: [
        kanbanStateNotifierProvider.overrideWith((ref) => mockKanbanNotifier),
        authStateNotifierProvider.overrideWith((ref) => mockAuthNotifier),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('KanbanScreen Widget Tests', () {
    testWidgets('displays loading indicator when loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        () => mockKanbanNotifier.state,
      ).thenReturn(const AsyncLoading<List<TaskEntity>>());

      // Act
      await tester.pumpWidget(createTestApp(const KanbanScreen()));

      // Assert
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });
  });
}
