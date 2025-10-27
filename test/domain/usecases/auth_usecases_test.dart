import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_assignment/data/models/user_model.dart';
import 'package:kanban_assignment/domain/repositories/auth_repo.dart';
import 'package:kanban_assignment/domain/usecases/auth_usecases/get_current_user.dart';
import 'package:kanban_assignment/domain/usecases/auth_usecases/is_logged_in.dart';
import 'package:kanban_assignment/domain/usecases/auth_usecases/login_user.dart';
import 'package:kanban_assignment/domain/usecases/auth_usecases/logout_user.dart';
import 'package:kanban_assignment/domain/usecases/auth_usecases/register_user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  const testEmail = 'test@example.com';
  const testPassword = '123456';
  final testUser = UserModel(userEmail: testEmail, userId: 'uid123');

  group('Auth UseCases', () {
    test('LoginUser calls AuthRepository.login correctly', () async {
      final useCase = LoginUser(mockRepo);
      when(
        () => mockRepo.login(testEmail, testPassword),
      ).thenAnswer((_) async {});

      await useCase(testEmail, testPassword);

      verify(() => mockRepo.login(testEmail, testPassword)).called(1);
    });

    test('RegisterUser calls AuthRepository.register correctly', () async {
      final useCase = RegisterUser(mockRepo);
      when(
        () => mockRepo.register(testEmail, testPassword),
      ).thenAnswer((_) async {});

      await useCase(testEmail, testPassword);

      verify(() => mockRepo.register(testEmail, testPassword)).called(1);
    });

    test('LogoutUser calls AuthRepository.logout correctly', () async {
      final useCase = LogoutUser(mockRepo);
      when(() => mockRepo.logout()).thenAnswer((_) async {});

      await useCase();

      verify(() => mockRepo.logout()).called(1);
    });

    test(
      'IsLoggedIn calls AuthRepository.isLoggedIn and returns value',
      () async {
        final useCase = IsLoggedIn(mockRepo);
        when(() => mockRepo.isLoggedIn()).thenAnswer((_) async => true);

        final result = await useCase();

        expect(result, true);
        verify(() => mockRepo.isLoggedIn()).called(1);
      },
    );

    test(
      'GetCurrentUser calls AuthRepository.getCurrentUser and returns user',
      () async {
        final useCase = GetCurrentUser(mockRepo);
        when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => testUser);

        final result = await useCase();

        expect(result, equals(testUser));
        verify(() => mockRepo.getCurrentUser()).called(1);
      },
    );
  });
}
