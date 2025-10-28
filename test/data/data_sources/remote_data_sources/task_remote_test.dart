import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_assignment/core/helpers/firebase_helper.dart';
import 'package:kanban_assignment/data/data_sources/remote_data_sources/task_data_source.dart';
import 'package:kanban_assignment/data/models/task_model.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_remote_test.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

void main() {
  late TaskRemoteDataSource dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollectionRef;
  late MockDocumentReference mockDocRef;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDoc;
  late MockFirebaseAuth mockFirebaseAuth;
  late FirebaseHelper firebaseHelper;
  late MockDocumentSnapshot mockDocSnapshot;
  late MockQuery mockQuery;

  const testUserId = 'test-user-id';
  final testTask = TaskModel(
    id: 'test-id',
    title: 'Test Task',
    description: 'Test Description',
    status: 'todo',
  );

  setUpAll(() {
    registerFallbackValue(testTask.toFirestore());
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollectionRef = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDoc = MockQueryDocumentSnapshot();
    mockFirebaseAuth = MockFirebaseAuth();
    mockDocSnapshot = MockDocumentSnapshot();
    mockQuery = MockQuery();

    // inject mock Firestore
    firebaseHelper = FirebaseHelper(
      firestore: mockFirestore,
      auth: mockFirebaseAuth,
    );
    dataSource = TaskRemoteDataSource(firebaseHelper);
  });

  group('TaskRemoteDataSource', () {
    test('getTasks should return a Stream<List<TaskModel>>', () async {
      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(testUserId)).thenReturn(mockDocRef);
      when(() => mockDocRef.collection('tasks')).thenReturn(mockCollectionRef);

      when(() => mockCollectionRef.orderBy('title')).thenReturn(mockQuery);
      when(
        () => mockQuery.snapshots(),
      ).thenAnswer((_) => Stream.value(mockQuerySnapshot));

      when(() => mockQueryDoc.id).thenReturn('t1');
      when(() => mockQueryDoc.data()).thenReturn(testTask.toFirestore());
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDoc]);

      // Act
      final resultStream = dataSource.getTasks(testUserId);

      // Assert
      await expectLater(
        resultStream,
        emits(
          isA<List<TaskModel>>()
              .having((tasks) => tasks.length, 'length', 1)
              .having((tasks) => tasks.first.title, 'title', 'Test Task'),
        ),
      );

      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollectionRef.doc(testUserId)).called(1);
      verify(() => mockDocRef.collection('tasks')).called(1);
      verify(() => mockCollectionRef.orderBy('title')).called(1);
      verify(() => mockQuery.snapshots()).called(1);
    });

    test('addTask calls Firestore with correct data', () async {
      // Arrange
      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(testUserId)).thenReturn(mockDocRef);
      when(() => mockDocRef.collection('tasks')).thenReturn(mockCollectionRef);
      when(
        () => mockCollectionRef.add(any()),
      ).thenAnswer((_) async => mockDocRef);

      // Act
      await dataSource.addTask(testUserId, testTask);

      // Assert
      verify(() => mockCollectionRef.add(testTask.toFirestore())).called(1);
    });

    test('updateTask updates task correctly', () async {
      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(testUserId)).thenReturn(mockDocRef);
      when(() => mockDocRef.collection('tasks')).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(testTask.id)).thenReturn(mockDocRef);
      when(
        () => mockDocRef.update(any()),
      ).thenAnswer((_) async => Future.value());

      await dataSource.updateTask(testUserId, testTask);

      verify(() => mockDocRef.update(testTask.toFirestore())).called(1);
    });

    test('deleteTask deletes document correctly', () async {
      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(testUserId)).thenReturn(mockDocRef);
      when(() => mockDocRef.collection('tasks')).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(testTask.id)).thenReturn(mockDocRef);
      when(() => mockDocRef.delete()).thenAnswer((_) async => Future.value());

      await dataSource.deleteTask(testUserId, testTask.id);

      verify(() => mockDocRef.delete()).called(1);
    });
  });
}
