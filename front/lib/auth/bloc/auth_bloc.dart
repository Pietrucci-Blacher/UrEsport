import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:uresport/core/models/register_request.dart';
import 'package:uresport/core/models/login_request.dart';
import 'package:uresport/core/services/cache_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      final isLoggedIn = await authService.isLoggedIn();
      if (isLoggedIn) {
        final user = await authService.getUser();
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoggedIn>((event, emit) async {
      final user = await authService.getUser();
      emit(AuthAuthenticated(user));
    });

    on<AuthLoggedOut>((event, emit) async {
      await authService.logout();
      emit(AuthUnauthenticated());
    });

    on<OAuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.loginWithOAuth(event.provider);
        final user = await authService.getUser();
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.register(
          RegisterRequest(
            firstName: event.firstName,
            lastName: event.lastName,
            userName: event.username,
            email: event.email,
            password: event.password,
          ),
        );
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await authService.login(
          LoginRequest(
            email: event.email,
            password: event.password,
          ),
        );
        await CacheService.instance.setString('token', token);
        final user = await authService.getUser();
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<PasswordResetRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.requestPasswordReset(event.email);
        emit(PasswordResetEmailSent());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<VerificationRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.requestVerification(event.email);
        emit(VerificationEmailSent());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<PasswordResetConfirmRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.resetPassword(event.code, event.newPassword);
        emit(PasswordResetConfirmed());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<VerifyCodeSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.verifyCode(event.email, event.code);
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
