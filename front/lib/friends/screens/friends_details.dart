import 'package:flutter/material.dart';
import '../../models/friends.dart'; // Assurez-vous que le chemin est correct

class FriendsDetails extends StatelessWidget {
  final Friend friend;

  const FriendsDetails({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'ami'),
      ),
      body: Center(
        child: Text(
          'Détails pour ${friend.name}', // Utilisez les détails de l'ami
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
