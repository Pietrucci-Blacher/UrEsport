// join_button.dart
import 'package:flutter/material.dart';

class JoinButton extends StatelessWidget {
  final String username;
  final String tournamentId;

  const JoinButton({Key? key, required this.username, required this.tournamentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Ajoutez ici la logique pour rejoindre le tournoi
        bool joinSuccess = true; // Remplacez cela par votre logique réelle
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(joinSuccess ? 'Succès' : 'Échec'),
              content: Text(joinSuccess ? 'Vous avez bien rejoint le tournoi !' : 'Impossible de rejoindre le tournoi.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Rejoindre'),
    );
  }
}
