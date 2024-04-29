import 'package:flutter/material.dart';
import 'package:uresport/auth/services/auth_service.dart';

class LoginRegisterScreen extends StatefulWidget {
  final IAuthService authService;

  const LoginRegisterScreen({super.key, required this.authService});

  @override
  LoginRegisterScreenState createState() => LoginRegisterScreenState();
}

class LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    try {
      await widget.authService
          .login(_emailController.text, _passwordController.text);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _handleRegister() async {
    try {
      await widget.authService.register(
          _emailController.text,
          _passwordController.text,
          _firstnameController.text,
          _lastnameController.text,
          _usernameController.text);
    } catch (e) {
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
    return Scaffold(
      appBar: AppBar(title: const Text("Login / Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _firstnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _handleLogin, child: const Text('Login')),
            ElevatedButton(
                onPressed: _handleRegister, child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
