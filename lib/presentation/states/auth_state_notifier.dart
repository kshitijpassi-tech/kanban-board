import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import '../../core/di/injection_container.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/auth_usecases/get_current_user_usecase.dart';
import '../../domain/usecases/auth_usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/auth_usecases/login_user_usecase.dart';
import '../../domain/usecases/auth_usecases/logout_user_usecase.dart';
import '../../domain/usecases/auth_usecases/register_user_usecase.dart';

class AuthStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final GetCurrentUserUseCase _getCurrentUser;
  final IsLoggedInUseCase _isLoggedIn;
  final LoginUserUseCase _loginUser;
  final RegisterUserUseCase _registerUser;
  final LogoutUserUseCase _logoutUser;

  AuthStateNotifier(
    this._getCurrentUser,
    this._isLoggedIn,
    this._loginUser,
    this._registerUser,
    this._logoutUser,
  ) : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = const AsyncValue.loading();
    final isLoggedIn = await _isLoggedIn.call();
    if (isLoggedIn) {
      final user = await _getCurrentUser.call();
      state = AsyncValue.data(user);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    await _loginUser.call(email, password);
    final user = await _getCurrentUser.call();
    state = AsyncValue.data(user);
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    await _registerUser.call(email, password);
    final user = await _getCurrentUser.call();
    state = AsyncValue.data(user);
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _logoutUser.call();
    state = const AsyncValue.data(null);
  }

  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();
    final user = await _getCurrentUser.call();
    state = AsyncValue.data(user);
  }

  Future<bool> isLoggedIn() async {
    return await _isLoggedIn.call();
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
      final getCurrentUser = sl<GetCurrentUserUseCase>();
      final isLoggedIn = sl<IsLoggedInUseCase>();
      final loginUser = sl<LoginUserUseCase>();
      final registerUser = sl<RegisterUserUseCase>();
      final logoutUser = sl<LogoutUserUseCase>();

      return AuthStateNotifier(
        getCurrentUser,
        isLoggedIn,
        loginUser,
        registerUser,
        logoutUser,
      );
    });
