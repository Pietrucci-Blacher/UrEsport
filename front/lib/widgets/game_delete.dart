import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameDeleteButton extends StatelessWidget {
  final Game game;
  final VoidCallback onDeleteSuccess; // Callback pour la redirection après la suppression réussie

  const GameDeleteButton({Key? key, required this.game, required this.onDeleteSuccess}) : super(key: key);

  Future<void> _deleteGame(BuildContext context) async {
    final url = 'http://10.0.2.2:8080/games/${game.id}';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 204 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le jeu a été supprimé avec succès')),
      );
      // Appeler le callback pour la redirection
      onDeleteSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la suppression du jeu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('Voulez-vous vraiment supprimer ce jeu ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    _deleteGame(context);
                  },
                  child: Text('Supprimer'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Supprimer le jeu'),
    );
  }
}
