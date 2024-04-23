import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
                // Simulate a login
                setState(() {
                  isLoggedIn = true;
                });
              },
              child: const Text('Log In'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoggedIn = true;
                });
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
