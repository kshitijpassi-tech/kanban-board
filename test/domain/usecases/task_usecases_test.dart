import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_assignment/domain/entities/task_entity.dart';
import 'package:kanban_assignment/domain/repositories/task_repo.dart';
import 'package:kanban_assignment/domain/usecases/task_usecases/add_task.dart';
import 'package:kanban_assignment/domain/usecases/task_usecases/delete_task.dart';
import 'package:kanban_assignment/domain/usecases/task_usecases/get_task.dart';
import 'package:kanban_assignment/domain/usecases/task_usecases/update_task.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepo;

  setUp(() {
    mockRepo = MockTaskRepository();
  });

  const testUserId = 'user123';
  const testTaskId = 'task123';
  final testTask = TaskEntity(
    id: testTaskId,
    title: 'Test Task',
    description: 'Description',
    status: 'todo',
  );

  setUpAll(() {
    registerFallbackValue(testTask);
  });

  group('Task UseCases', () {
    test('AddTask calls TaskRepository.addTask with correct params', () async {
      final useCase = AddTask(mockRepo);
      when(
        () => mockRepo.addTask(testUserId, testTask),
      ).thenAnswer((_) async {});

      await useCase(testUserId, testTask);

      verify(() => mockRepo.addTask(testUserId, testTask)).called(1);
    });

    test(
      'UpdateTask calls TaskRepository.updateTask with correct params',
      () async {
        final useCase = UpdateTask(mockRepo);
        when(
          () => mockRepo.updateTask(testUserId, testTask),
        ).thenAnswer((_) async {});

        await useCase(testUserId, testTask);

        verify(() => mockRepo.updateTask(testUserId, testTask)).called(1);
      },
    );

    test(
      'DeleteTask calls TaskRepository.deleteTask with correct params',
      () async {
        final useCase = DeleteTask(mockRepo);
        when(
          () => mockRepo.deleteTask(testUserId, testTaskId),
        ).thenAnswer((_) async {});

        await useCase(testUserId, testTaskId);

        verify(() => mockRepo.deleteTask(testUserId, testTaskId)).called(1);
      },
    );

    test('GetTask calls TaskRepository.getTasks and returns stream', () async {
      final useCase = GetTask(mockRepo);
      final tasksStream = Stream.value([testTask]);
      when(() => mockRepo.getTasks(testUserId)).thenAnswer((_) => tasksStream);

      final result = useCase(testUserId);

      expect(result, emits([testTask]));
      verify(() => mockRepo.getTasks(testUserId)).called(1);
    });
  });

  group('Task UseCases Error Propagation', () {
    test('AddTask rethrows exceptions from repository', () async {
      final useCase = AddTask(mockRepo);
      when(
        () => mockRepo.addTask(any(), any()),
      ).thenThrow(Exception('Add failed'));

      expect(() => useCase(testUserId, testTask), throwsA(isA<Exception>()));
    });

    test('UpdateTask rethrows exceptions from repository', () async {
      final useCase = UpdateTask(mockRepo);
      when(
        () => mockRepo.updateTask(any(), any()),
      ).thenThrow(Exception('Update failed'));

      expect(() => useCase(testUserId, testTask), throwsA(isA<Exception>()));
    });

    test('DeleteTask rethrows exceptions from repository', () async {
      final useCase = DeleteTask(mockRepo);
      when(
        () => mockRepo.deleteTask(any(), any()),
      ).thenThrow(Exception('Delete failed'));

      expect(() => useCase(testUserId, testTaskId), throwsA(isA<Exception>()));
    });
  });
}
