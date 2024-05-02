import 'package:flutter/material.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/models/login_request.dart';
import 'package:uresport/core/services/cache_service.dart';
import 'package:uresport/home/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final IAuthService authService;

  const LoginScreen({super.key, required this.authService});

  @override LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    try {
      final token = await widget.authService.login(
        LoginRequest(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );

      // Inject token into cache upon successful login
      await CacheService.instance.setString('token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
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
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              autofillHints: const [AutofillHints.password],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _handleLogin, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
