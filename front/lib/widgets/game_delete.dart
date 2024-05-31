import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uresport/core/models/game.dart';

class GameDeleteButton extends StatelessWidget {
  final Game game;
  final VoidCallback onDeleteSuccess;

  const GameDeleteButton({
    super.key,
    required this.game,
    required this.onDeleteSuccess,
  });

  Future<void> _deleteGame(BuildContext context) async {
    final url = Uri.parse('http://10.0.2.2:8080/games/${game.id}');
    final messenger = ScaffoldMessenger.of(context);
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Le jeu a été supprimé avec succès')),
        );
        onDeleteSuccess();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du jeu: $e')),
      );
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment supprimer ce jeu ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _deleteGame(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _confirmDelete(context),
      child: const Text('Supprimer le jeu'),
    );
  }
}
