import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth_usecases/get_current_user_usecase.dart';
import '../../../domain/usecases/auth_usecases/login_user_usecase.dart';
import '../../../domain/usecases/auth_usecases/logout_user_usecase.dart';
import '../../../domain/usecases/auth_usecases/register_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUseCase _loginUserUseCase;
  final RegisterUserUseCase _registerUserUseCase;
  final LogoutUserUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(
    this._getCurrentUserUseCase,
    this._loginUserUseCase,
    this._logoutUseCase,
    this._registerUserUseCase,
  ) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _loginUserUseCase(event.email, event.password);
        final user = await _getCurrentUserUseCase();
        emit(Authenticated(user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _registerUserUseCase(event.email, event.password);
        final user = await _getCurrentUserUseCase();
        emit(Authenticated(user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await _logoutUseCase();
      emit(Unauthenticated());
    });

    on<CheckAuthStatusEvent>((event, emit) async {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
