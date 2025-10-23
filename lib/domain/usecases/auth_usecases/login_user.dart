import '../../repositories/auth_repo.dart';

class LoginUser {
  final AuthRepository _authRepository;
  LoginUser(this._authRepository);

  Future<void> call(String email, String password) {
    return _authRepository.login(email, password);
  }
}
