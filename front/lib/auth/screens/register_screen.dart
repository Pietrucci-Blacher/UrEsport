import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/models/register_request.dart';

class RegisterScreen extends StatefulWidget {
  final IAuthService authService;

  const RegisterScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        RegisterRequest(
          firstName: _firstnameController.text,
          lastName: _lastnameController.text,
          userName: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
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
              autofillHints: const [AutofillHints.givenName],
            ),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.familyName],
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              autofillHints: const [AutofillHints.username],
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _handleRegister, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}
