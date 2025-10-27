import '../../repositories/auth_repo.dart';

class IsLoggedInUseCase {
  final AuthRepository _authRepository;
  IsLoggedInUseCase(this._authRepository);

  Future<bool> call() {
    return _authRepository.isLoggedIn();
  }
}
