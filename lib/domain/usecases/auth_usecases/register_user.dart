import '../../repositories/auth_repo.dart';

class RegisterUser {
  final AuthRepository _authRepository;
  RegisterUser(this._authRepository);

  Future<void> call(String email, String password) {
    return _authRepository.register(email, password);
  }
}
