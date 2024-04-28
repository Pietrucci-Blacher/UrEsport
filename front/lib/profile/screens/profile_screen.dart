import 'package:flutter/material.dart';
import 'package:uresport/auth/screens/login_register_screen.dart';
import 'package:uresport/auth/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final IAuthService authService;

  const ProfileScreen({super.key, required this.authService});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: isLoggedIn
          ? const Center(child: Text('Welcome to your profile!'))
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You are not logged in'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginRegisterScreen(authService: widget.authService),
                  ),
                );
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
