import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/models/login_request.dart';
import 'package:uresport/core/services/cache_service.dart';

// Event
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
}

// State
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

// Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthService authService;

  LoginBloc({required this.authService}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  void _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());
    try {
      final token = await authService.login(
        LoginRequest(
          email: event.email,
          password: event.password,
        ),
      );
      await CacheService.instance.setString('token', token);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}

// UI
class LoginScreen extends StatelessWidget {
  final IAuthService authService;

  const LoginScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authService: authService),
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EmailInput(),
              _PasswordInput(),
              const SizedBox(height: 20),
              _LoginButton(),
              _LoginError(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      onChanged: (value) => context.read<LoginBloc>().add(
        LoginButtonPressed(email: value, password: ''),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      autofillHints: const [AutofillHints.password],
      onChanged: (value) => context.read<LoginBloc>().add(
        LoginButtonPressed(email: '', password: value),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginLoading) {
          return const CircularProgressIndicator();
        }
        return ElevatedButton(
          onPressed: () {
            final email = (context.read<LoginBloc>().state as LoginButtonPressed).email;
            final password = (context.read<LoginBloc>().state as LoginButtonPressed).password;
            context.read<LoginBloc>().add(LoginButtonPressed(email: email, password: password));
          },
          child: const Text('Login'),
        );
      },
    );
  }
}

class _LoginError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginFailure) {
          return Text(
            state.error,
            style: const TextStyle(color: Colors.red),
          );
        }
        return Container();
      },
    );
  }
}
