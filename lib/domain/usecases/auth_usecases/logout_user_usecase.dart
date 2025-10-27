import '../../repositories/auth_repo.dart';

class LogoutUserUseCase {
  final AuthRepository _authRepository;
  LogoutUserUseCase(this._authRepository);

  Future<void> call() {
    return _authRepository.logout();
  }
}
