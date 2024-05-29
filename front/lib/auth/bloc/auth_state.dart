class User {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? avatarUrl;

  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.avatarUrl,
  });
}

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

class PasswordResetConfirmed extends AuthState {}

class AuthRegistrationSuccess extends AuthState {}
