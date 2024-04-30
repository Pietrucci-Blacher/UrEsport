import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uresport/auth/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final IAuthService authService;

  const RegisterScreen({super.key, required this.authService});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    try {
      await widget.authService.register(
        _firstnameController.text,
        _lastnameController.text,
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Registration failed with error: $e");
      }
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _firstnameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: _lastnameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _handleRegister, child: const Text("Register"))
            ],
          )
      ),
    );
  }
}
