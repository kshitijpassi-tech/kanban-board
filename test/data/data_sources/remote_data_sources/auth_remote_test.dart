import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_assignment/data/data_sources/remote_data_sources/auth_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class MockFirestore extends Mock implements fs.FirebaseFirestore {}

class MockUserCredential extends Mock implements fb.UserCredential {}

class MockFbUser extends Mock implements fb.User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirestore mockFirestore;
  late AuthDataSource dataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirestore();
    dataSource = AuthDataSource(mockFirestore, mockFirebaseAuth);
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

    // verify that signInWithEmailAndPassword was called with correct args
    verify(
      () => mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: '1234',
      ),
    ).called(1);
  });
}
