import '../../repositories/auth_repo.dart';

class LogoutUser {
  final AuthRepository _authRepository;
  LogoutUser(this._authRepository);

  Future<void> call() {
    return _authRepository.logout();
  }
}
