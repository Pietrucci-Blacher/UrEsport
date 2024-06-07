import 'package:flutter/material.dart';
import '../../models/friend.dart'; // Assurez-vous que le chemin est correct

class FriendsDetails extends StatelessWidget {
  final Friend friend;

  FriendsDetails({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'ami'),
      ),
      body: Center(
        child: Text(
          'Détails pour ${friend.name}', // Utilisez les détails de l'ami
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
