import 'package:uresport/core/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class PasswordResetEmailSent extends AuthState {}

class VerificationEmailSent extends AuthState {}

class PasswordResetConfirmed extends AuthState {}

class AuthRegistrationSuccess extends AuthState {}
