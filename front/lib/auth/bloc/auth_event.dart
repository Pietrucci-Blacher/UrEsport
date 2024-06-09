abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}

class OAuthLoginRequested extends AuthEvent {
  final String provider;
  OAuthLoginRequested(this.provider);
}

class RegisterSubmitted extends AuthEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;

  RegisterSubmitted({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
  });
}

class VerifyCodeSubmitted extends AuthEvent {
  final String email;
  final String code;

  VerifyCodeSubmitted({
    required this.email,
    required this.code,
  });
}

class PasswordResetRequested extends AuthEvent {
  final String email;
  PasswordResetRequested(this.email);
}

class VerificationRequested extends AuthEvent {
  final String email;
  VerificationRequested(this.email);
}

class PasswordResetConfirmRequested extends AuthEvent {
  final String code;
  final String newPassword;

  PasswordResetConfirmRequested(this.code, this.newPassword);
}

class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  LoginButtonPressed({
    required this.email,
    required this.password,
  });
}
