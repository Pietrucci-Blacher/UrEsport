import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/core/services/auth_service.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final IAuthService authService;

  const VerificationScreen({super.key, required this.email, required this.authService});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _codeControllers = List.generate(5, (index) => TextEditingController());
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _submitCode(BuildContext context) {
    final code = _codeControllers.map((controller) => controller.text).join();
    context.read<AuthBloc>().add(VerifyCodeSubmitted(email: widget.email, code: code));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(widget.authService),
      child: Scaffold(
        appBar: AppBar(title: const Text("Account Verification")),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
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
                  Text('A verification code has been sent to ${widget.email}.'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      return _buildCodeField(context, index);
                    }),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () => _submitCode(context),
                        child: const Text("Verify"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(BuildContext context, int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _codeControllers[index],
        focusNode: index == 0 ? _focusNode : null,
        autofocus: index == 0,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 4) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
