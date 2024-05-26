import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/core/services/auth_service.dart';

class ResetPasswordScreen extends StatelessWidget {
  final IAuthService authService;

  const ResetPasswordScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reset Password')),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is PasswordResetEmailSent) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset email sent')));
            } else if (state is PasswordResetConfirmed) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset successful')));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your email to reset password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _ResetPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordForm extends StatefulWidget {
  @override
  __ResetPasswordFormState createState() => __ResetPasswordFormState();
}

class __ResetPasswordFormState extends State<_ResetPasswordForm> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(PasswordResetRequested(_emailController.text));
          },
          child: const Text('Send Reset Email'),
        ),
      ],
    );
  }
}
