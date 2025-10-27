import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_assignment/data/data_sources/remote_data_sources/task_data_source.dart';
import 'package:kanban_assignment/data/models/task_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

void main() {
  late TaskRemoteDataSource dataSource;
  late MockFirebaseFirestore mockFirestore;
  final testUserId = 'test-user-id';

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    dataSource = TaskRemoteDataSource(mockFirestore);
  });

  group('TaskRemoteDataSource', () {
    final testTask = TaskModel(
      id: 'test-id',
      title: 'Test Task',
      description: 'Test Description',
      status: 'todo',
    );

    test('getTasks returns stream of tasks', () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final realDataSource = TaskRemoteDataSource(fakeFirestore);

      // Add test data
      await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('tasks')
          .add(testTask.toFirestore());

      // Get stream
      final stream = realDataSource.getTasks(testUserId);

      // Verify
      expect(stream, emits(isA<List<TaskModel>>()));
    });

    test('addTask adds task to firestore', () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final realDataSource = TaskRemoteDataSource(fakeFirestore);

      // Add task
      await realDataSource.addTask(testUserId, testTask);

      // Verify
      final snapshot = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('tasks')
          .get();

      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first.data()['title'], testTask.title);
    });

    test('updateTask updates existing task', () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final realDataSource = TaskRemoteDataSource(fakeFirestore);

      final testTask = TaskModel(
        id: 't1',
        title: 'Task 1',
        description: 'Desc',
        status: 'todo',
      );

      final docRef = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('tasks')
          .add(testTask.toFirestore());

      final updatedTask = testTask.copyWith(
        id: docRef.id,
        title: 'Updated Title',
      );

      await realDataSource.updateTask(
        testUserId,
        TaskModel.fromEntity(updatedTask),
      );

      final doc = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('tasks')
          .doc(docRef.id)
          .get();

      expect(doc.data()?['title'], 'Updated Title');
    });

    test('deleteTask removes task', () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final realDataSource = TaskRemoteDataSource(fakeFirestore);

      // Add task
      final docRef = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('tasks')
          .add(testTask.toFirestore());

      // Delete task
      await realDataSource.deleteTask(testUserId, docRef.id);

      // Verify
      final doc = await fakeFirestore
          .collection('users')
          .doc(testUserId)
          .collection('tasks')
          .doc(docRef.id)
          .get();

      expect(doc.exists, false);
    });
  });
}
