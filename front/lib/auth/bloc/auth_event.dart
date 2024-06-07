import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}

class OAuthLoginRequested extends AuthEvent {
  final String provider;
  const OAuthLoginRequested(this.provider);

  @override
  List<Object> get props => [provider];
}

class RegisterSubmitted extends AuthEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, username, email, password];
}

class VerifyCodeSubmitted extends AuthEvent {
  final String email;
  final String code;

  const VerifyCodeSubmitted({
    required this.email,
    required this.code,
  });

  @override
  List<Object> get props => [email, code];
}

class PasswordResetRequested extends AuthEvent {
  final String email;
  const PasswordResetRequested(this.email);

  @override
  List<Object> get props => [email];
}

class VerificationRequested extends AuthEvent {
  final String email;
  const VerificationRequested(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordResetConfirmRequested extends AuthEvent {
  final String code;
  final String newPassword;

  const PasswordResetConfirmRequested(this.code, this.newPassword);

  @override
  List<Object> get props => [code, newPassword];
}

class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
