import '../../../data/models/user_model.dart';
import '../../repositories/auth_repo.dart';

class GetCurrentUser {
  final AuthRepository _authRepository;
  GetCurrentUser(this._authRepository);

  Future<UserModel?> call() {
    return _authRepository.getCurrentUser();
  }
}
