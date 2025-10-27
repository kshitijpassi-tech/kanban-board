import '../../repositories/auth_repo.dart';

class RegisterUserUseCase {
  final AuthRepository _authRepository;
  RegisterUserUseCase(this._authRepository);

  Future<void> call(String email, String password) {
    return _authRepository.register(email, password);
  }
}
