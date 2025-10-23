import '../../repositories/auth_repo.dart';

class IsLoggedIn {
  final AuthRepository _authRepository;
  IsLoggedIn(this._authRepository);

  Future<bool> call() {
    return _authRepository.isLoggedIn();
  }
}
