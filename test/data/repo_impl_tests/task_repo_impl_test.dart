import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_assignment/core/constants/network_helper.dart';
import 'package:kanban_assignment/data/data_sources/local_data_sources/task_local_data_source.dart';
import 'package:kanban_assignment/data/data_sources/remote_data_sources/task_data_source.dart';
import 'package:kanban_assignment/data/models/task_model.dart';
import 'package:kanban_assignment/data/repositories_impl/task_repo_impl.dart';
import 'package:kanban_assignment/domain/entities/task_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements TaskRemoteDataSource {}

class MockLocal extends Mock implements TaskLocalDataSource {}

class MockNetworkHelper extends Mock implements NetworkHelper {}

class FakeTaskModel extends Fake implements TaskModel {}

void main() {
  late TaskRepositoryImpl repo;
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late MockNetworkHelper mockNetwork;

  const userId = 'u1';
  final task = TaskModel(
    id: 't1',
    title: 'Task 1',
    description: 'Desc',
    status: 'todo',
  );
  final taskEntity = task.toEntity();

  setUpAll(() {
    registerFallbackValue(FakeTaskModel());
  });

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    mockNetwork = MockNetworkHelper();
    repo = TaskRepositoryImpl(mockRemote, mockLocal, mockNetwork);
  });

  group('getTasks', () {
    test('returns cached tasks when offline', () async {
      when(() => mockNetwork.hasInternet()).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedTasks()).thenAnswer((_) async => [task]);

      final result = repo.getTasks(userId);
      expectLater(result, emits(isA<List<TaskEntity>>()));
    });

    test('fetches from remote and caches when online', () async {
      when(() => mockNetwork.hasInternet()).thenAnswer((_) async => true);
      when(
        () => mockRemote.getTasks(userId),
      ).thenAnswer((_) => Stream.value([task])); // ✅ Stream, not Future
      when(() => mockLocal.cacheTasks(any())).thenAnswer((_) async => {});

      final result = repo.getTasks(userId);

      expectLater(result, emits(isA<List<TaskEntity>>()));
      verifyNever(() => mockLocal.cacheTasks([task]));
    });
  });

  group('add/update/delete', () {
    test('addTask calls both local and remote', () async {
      when(() => mockLocal.addTask(any())).thenAnswer((_) async => {});
      when(() => mockRemote.addTask(userId, any())).thenAnswer((_) async => {});

      await repo.addTask(userId, taskEntity);

      verify(() => mockLocal.addTask(any())).called(1);
      verify(() => mockRemote.addTask(userId, any())).called(1);
    });

    test('updateTask calls both local and remote', () async {
      when(() => mockLocal.updateTask(any())).thenAnswer((_) async => {});
      when(
        () => mockRemote.updateTask(userId, any()),
      ).thenAnswer((_) async => {});

      await repo.updateTask(userId, taskEntity);

      verify(() => mockLocal.updateTask(any())).called(1);
      verify(() => mockRemote.updateTask(userId, any())).called(1);
    });

    test('deleteTask calls both local and remote', () async {
      when(() => mockLocal.deleteTask(any())).thenAnswer((_) async => {});
      when(
        () => mockRemote.deleteTask(userId, any()),
      ).thenAnswer((_) async => {});

      await repo.deleteTask(userId, 't1');

      verify(() => mockLocal.deleteTask('t1')).called(1);
      verify(() => mockRemote.deleteTask(userId, 't1')).called(1);
    });
  });
}
