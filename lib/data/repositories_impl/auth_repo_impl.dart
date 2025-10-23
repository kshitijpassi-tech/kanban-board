import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../data_sources/remote_data_sources/auth_data_source.dart';
import '../models/user_model.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepoImpl(this._authDataSource);

  @override
  Future<UserModel?> getCurrentUser() => _authDataSource.getCurrentUser();

  @override
  Future<bool> isLoggedIn() => _authDataSource.isSignedIn();

  @override
  Future<void> login(String email, String password) =>
      _authDataSource.login(email, password);

  @override
  Future<void> logout() => _authDataSource.logout();

  @override
  Future<void> register(String email, String password) =>
      _authDataSource.register(email, password);
}
