// invite_button.dart
import 'package:flutter/material.dart';

class InviteButton extends StatelessWidget {
  final String username;
  final String tournamentId;

  const InviteButton({Key? key, required this.username, required this.tournamentId}) : super(key: key);

  Future<void> joinTournament() async {
    // Ici, vous pouvez ajouter la logique pour rejoindre le tournoi.
    // Par exemple, vous pouvez envoyer une requête HTTP à votre serveur.
    // Pour l'instant, nous affichons simplement un message.
    print('Rejoindre le tournoi');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alerte'),
      content: Text('Bonjour, $username'),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Rejoindre'),
          onPressed: () {
            joinTournament();
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton( // Ajout du deuxième bouton
          onPressed: () {
            // Ajoutez ici la logique pour le deuxième bouton
            // Par exemple, pour envoyer une invitation à un tournoi
            print('Inviter $username au tournoi $tournamentId');
          },
          child: const Text('Inviter'),
        ),
      ],
    );
  }
}
