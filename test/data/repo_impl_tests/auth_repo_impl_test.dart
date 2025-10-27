import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_assignment/data/data_sources/remote_data_sources/auth_data_source.dart';
import 'package:kanban_assignment/data/models/user_model.dart';
import 'package:kanban_assignment/data/repositories_impl/auth_repo_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  late AuthRepoImpl repo;
  late MockAuthDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthDataSource();
    repo = AuthRepoImpl(mockDataSource);
  });

  const email = 'test@example.com';
  const password = '123456';
  final user = UserModel(userEmail: email, userId: 'uid123');

  test('login calls dataSource.login', () async {
    when(
      () => mockDataSource.login(email, password),
    ).thenAnswer((_) async => {});
    await repo.login(email, password);
    verify(() => mockDataSource.login(email, password)).called(1);
  });

  test('getCurrentUser delegates to dataSource', () async {
    when(() => mockDataSource.getCurrentUser()).thenAnswer((_) async => user);
    final result = await repo.getCurrentUser();
    expect(result, user);
  });

  test('logout calls dataSource.logout', () async {
    when(() => mockDataSource.logout()).thenAnswer((_) async => {});
    await repo.logout();
    verify(() => mockDataSource.logout()).called(1);
  });
}
