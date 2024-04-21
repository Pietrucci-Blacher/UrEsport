import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                // Simuler une connexion
                setState(() {
                  isLoggedIn = true;
                });
              },
              child: const Text('Log In'),
            ),
            const SizedBox(height: 10),  // Espacement entre les boutons
            ElevatedButton(
              onPressed: () {
                // Simuler un enregistrement ou ouvrir un formulaire d'enregistrement
                setState(() {
                  isLoggedIn = true; // Modifier selon votre logique d'authentification réelle
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
