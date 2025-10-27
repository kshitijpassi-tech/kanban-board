import '../../repositories/auth_repo.dart';

class LoginUserUseCase {
  final AuthRepository _authRepository;
  LoginUserUseCase(this._authRepository);

  Future<void> call(String email, String password) {
    return _authRepository.login(email, password);
  }
}
