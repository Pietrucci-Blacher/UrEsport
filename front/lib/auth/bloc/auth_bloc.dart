import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      final isLoggedIn = await authService.isLoggedIn();
      if (isLoggedIn) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoggedIn>((event, emit) => emit(AuthAuthenticated()));

    on<AuthLoggedOut>((event, emit) => emit(AuthUnauthenticated()));
  }
}
