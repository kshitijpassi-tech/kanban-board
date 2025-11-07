import '../../entities/user_entity.dart';
import '../../repositories/auth_repo.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;
  GetCurrentUserUseCase(this._authRepository);

  Future<UserEntity?> call() {
    return _authRepository.getCurrentUser();
  }
}
