abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}
