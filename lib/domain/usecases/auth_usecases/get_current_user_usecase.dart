import '../../../data/models/user_model.dart';
import '../../repositories/auth_repo.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;
  GetCurrentUserUseCase(this._authRepository);

  Future<UserModel?> call() {
    return _authRepository.getCurrentUser();
  }
}
