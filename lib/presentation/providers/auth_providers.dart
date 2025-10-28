import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/data_sources/remote_data_sources/auth_data_source.dart';
import '../../data/repositories_impl/auth_repo_impl.dart';
import '../../domain/usecases/auth_usecases/get_current_user_usecase.dart';
import '../../domain/usecases/auth_usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/auth_usecases/login_user_usecase.dart';
import '../../domain/usecases/auth_usecases/logout_user_usecase.dart';
import '../../domain/usecases/auth_usecases/register_user_usecase.dart';
import 'helper_providers.dart';

final authDataSorceProvider = Provider<AuthDataSource>((ref) {
  return AuthDataSource(ref.read(firebaseHelperProvider));
});

final authRepoimplProvider = Provider<AuthRepoImpl>((ref) {
  return AuthRepoImpl(ref.read(authDataSorceProvider));
});

final getCurrentUserProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.read(authRepoimplProvider));
});

final isLoggedInProvider = Provider<IsLoggedInUseCase>((ref) {
  return IsLoggedInUseCase(ref.read(authRepoimplProvider));
});

final loginUserProvider = Provider<LoginUserUseCase>((ref) {
  return LoginUserUseCase(ref.read(authRepoimplProvider));
});

final logoutProvider = Provider<LogoutUserUseCase>((ref) {
  return LogoutUserUseCase(ref.read(authRepoimplProvider));
});

final registerUserProvider = Provider<RegisterUserUseCase>((ref) {
  return RegisterUserUseCase(ref.read(authRepoimplProvider));
});
