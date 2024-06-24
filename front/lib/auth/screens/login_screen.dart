import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final IAuthService authService;
  final String? returnRoute;

  const LoginScreen({super.key, required this.authService, this.returnRoute});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onLoginButtonPressed(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthBloc>().add(
      LoginButtonPressed(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(widget.authService),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is AuthAuthenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: Stack(
            children: [
              _buildBackgroundImage(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40), // Ajoutez un espace pour le bouton de retour
                        const Align(
                          alignment: Alignment.topLeft,
                          child: BackButton(color: Colors.white),
                        ),
                        const SizedBox(height: 60), // Ajustez cet espace pour centrer le reste du contenu
                        _buildTitle(),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailController,
                          label: AppLocalizations.of(context).email,
                          hint: AutofillHints.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildPasswordField(),
                        const SizedBox(height: 10),
                        _buildForgotPassword(context),
                        const SizedBox(height: 20),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const CircularProgressIndicator();
                            }
                            return _buildLoginButton(context);
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildRegisterLink(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D005B), Color(0xFF000000)],
          stops: [0.1, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        SizedBox(height: 20),
        Text(
          'Login to your account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: keyboardType,
        autofillHints: hint != null ? [hint] : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _passwordController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).password,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: _togglePasswordVisibility,
          ),
        ),
        obscureText: _obscureText,
        autofillHints: const [AutofillHints.password],
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Implement forgot password navigation
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onLoginButtonPressed(context),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        AppLocalizations.of(context).login,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Implement navigation to register screen
      },
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(color: Colors.white70),
          children: [
            TextSpan(
              text: 'Create new account',
              style: TextStyle(color: Colors.pinkAccent),
            ),
          ],
        ),
      ),
    );
  }
}
