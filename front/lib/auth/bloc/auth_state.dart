import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class PasswordResetEmailSent extends AuthState {}

class VerificationEmailSent extends AuthState {}

class PasswordResetConfirmed extends AuthState {}

class AuthRegistrationSuccess extends AuthState {}
