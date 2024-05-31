import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:uresport/models/game.dart';

import 'game_delete.dart';
import 'game_modify.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;

  const GameDetailPage({Key? key, required this.game}) : super(key: key);
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
                child: ExtendedImage.network(
                  game.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  cache: true, // Enable caching
                  borderRadius: BorderRadius.circular(16.0), // Ensure borderRadius is defined
                  loadStateChanged: (state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return CircularProgressIndicator();
                      case LoadState.completed:
                        return null;
                      case LoadState.failed:
                        return Text('Failed to load image.');
                    }
                  },
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameModify(
                        game: game,
                        isEdit: true,
                    ),
                  ),
                );
              },
              child: const Text('Modifier le jeu'),
            ),
            GameDeleteButton(game: game, onDeleteSuccess: () => _redirectToGamesPage(context),),
          ],
        ),
      ),
    );
  }
}
