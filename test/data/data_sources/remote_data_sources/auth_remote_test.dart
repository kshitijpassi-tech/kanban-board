import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_assignment/core/helpers/firebase_helper.dart';
import 'package:kanban_assignment/data/data_sources/remote_data_sources/auth_data_source.dart';
import 'package:kanban_assignment/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class MockFirestore extends Mock implements fs.FirebaseFirestore {}

class MockUserCredential extends Mock implements fb.UserCredential {}

class MockFbUser extends Mock implements fb.User {}

class MockDocumentReference extends Mock
    implements fs.DocumentReference<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements fs.CollectionReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements fs.DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirestore mockFirestore;
  late AuthDataSource dataSource;
  late FirebaseHelper firebaseHelper;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirestore();
    firebaseHelper = FirebaseHelper(
      auth: mockFirebaseAuth,
      firestore: mockFirestore,
    );

    dataSource = AuthDataSource(firebaseHelper);
  });

  test('should return User when Firebase login succeeds', () async {
    final mockUser = MockFbUser();
    when(() => mockUser.uid).thenReturn('abc123');
    when(() => mockUser.email).thenReturn('test@example.com');

    final mockCred = MockUserCredential();
    when(() => mockCred.user).thenReturn(mockUser);

    when(
      () => mockFirebaseAuth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => mockCred);

    await dataSource.login('test@example.com', '1234');

    verify(
      () => mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: '1234',
      ),
    ).called(1);
  });

  test(
    'should create user and save to Firestore when register is called',
    () async {
      final mockUser = MockFbUser();
      when(() => mockUser.uid).thenReturn('uid123');
      when(() => mockUser.email).thenReturn('test@example.com');

      final mockCred = MockUserCredential();
      when(() => mockCred.user).thenReturn(mockUser);

      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('uid123')).thenReturn(mockDoc);
      when(() => mockDoc.set(any())).thenAnswer((_) async {});

      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockCred);

      await dataSource.register('test@example.com', 'password123');

      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);
      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollection.doc('uid123')).called(1);
      verify(() => mockDoc.set(any())).called(1);
    },
  );

  test('should call signOut when logout is called', () async {
    when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

    await dataSource.logout();

    verify(() => mockFirebaseAuth.signOut()).called(1);
  });

  group('isSignedIn', () {
    test('should return true when currentUser is not null', () async {
      final mockUser = MockFbUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final result = await dataSource.isSignedIn();

      expect(result, true);
    });

    test('should return false when currentUser is null', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await dataSource.isSignedIn();

      expect(result, false);
    });
  });

  group('getCurrentUser', () {
    test('should return UserModel when user exists in Firestore', () async {
      final mockUser = MockFbUser();
      when(() => mockUser.uid).thenReturn('uid123');
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockSnapshot = MockDocumentSnapshot();

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('uid123')).thenReturn(mockDoc);
      when(() => mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn({
        'userId': 'uid123',
        'userEmail': 'test@example.com',
      });

      final result = await dataSource.getCurrentUser();

      expect(result, isA<UserModel>());
      expect(result?.userId, 'uid123');
      expect(result?.userEmail, 'test@example.com');
    });

    test('should return null when user not signed in', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await dataSource.getCurrentUser();

      expect(result, isNull);
    });

    test('should return null when Firestore doc does not exist', () async {
      final mockUser = MockFbUser();
      when(() => mockUser.uid).thenReturn('uid123');
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final mockSnapshot = MockDocumentSnapshot();

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('uid123')).thenReturn(mockDoc);
      when(() => mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);

      final result = await dataSource.getCurrentUser();

      expect(result, isNull);
    });
  });
}
