import 'package:flutter/material.dart';
import 'package:uresport/auth/screens/login_screen.dart';
import 'package:uresport/auth/screens/register_screen.dart';
import 'package:uresport/auth/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final IAuthService authService;

  const ProfileScreen({super.key, required this.authService});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Future<bool> _isAuthenticatedFuture;

  @override
  void initState() {
    super.initState();
    _isAuthenticatedFuture = widget.authService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<bool>(
        future: _isAuthenticatedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !(snapshot.data ?? false)) {
            return _buildLoginRegisterButtons();
          } else {
            return _buildProfileScreen();
          }
        },
      ),
    );
  }

  Widget _buildLoginRegisterButtons() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You are not logged in'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen(authService: widget.authService)),
              );
            },
            child: const Text('Log In'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen(authService: widget.authService)),
              );
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to your profile!'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await widget.authService.logout();
              setState(() {
                _isAuthenticatedFuture = widget.authService.isLoggedIn(); // Refresh authentication status
              });
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
