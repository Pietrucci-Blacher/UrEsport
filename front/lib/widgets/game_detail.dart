import 'package:flutter/material.dart';
import 'package:uresport/core/models/game.dart';

import 'game_delete.dart';
import 'game_modify.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;

  const GameDetailPage({
    super.key,
    required this.game,
  });

  void _redirectToGamesPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/games');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  game.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              game.name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              game.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            Text('ID du jeu: ${game.id}'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navigateToModifyPage(context),
              child: const Text('Modifier le jeu'),
            ),
            GameDeleteButton(
              game: game,
              onDeleteSuccess: () => _redirectToGamesPage(context),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToModifyPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameModify(
          game: game,
          isEdit: true,
        ),
      ),
    );
  }
}
