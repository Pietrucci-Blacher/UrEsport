import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/l10n/app_localizations.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final IAuthService authService;

  const VerificationScreen(
      {super.key, required this.email, required this.authService});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitCode(BuildContext context) {
    final code = _codeController.text;
    context
        .read<AuthBloc>()
        .add(VerifyCodeSubmitted(email: widget.email, code: code));
    Navigator.pop(context);
  }

  void _resendCode(BuildContext context) {
    context.read<AuthBloc>().add(PasswordResetRequested(widget.email));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).resetPassword),
        content: Text(AppLocalizations.of(context).sendResetEmail),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(widget.authService),
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).verify)),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is AuthAuthenticated) {
              Navigator.pop(context);
              // Redirection ou autre action après vérification réussie
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)
                      .verificationCodeSent(widget.email)),
                  const SizedBox(height: 20),
                  _buildCodeField(context),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () => _submitCode(context),
                        child: Text(AppLocalizations.of(context).verify),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _resendCode(context),
                    child: const Text('Resend Code'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(BuildContext context) {
    return TextField(
      controller: _codeController,
      focusNode: _focusNode,
      autofocus: true,
      textAlign: TextAlign.center,
      maxLength: 5,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: (value) {
        if (value.length == 5) {
          _submitCode(context);
        }
      },
      style:
          const TextStyle(letterSpacing: 30.0), // Crée l'effet visuel de carrés
    );
  }
}
