import 'package:flutter/material.dart';

import 'game_detail.dart';

class Game {
  final String name;
  final String description;
  final String imageUrl;

  Game({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class GamesScreen extends StatelessWidget {
  final List<Game> games = generateGames();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Display two games per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7, // Adjust aspect ratio for better aesthetics
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            Game game = games[index];
            return GameCard(game: game);
          },
        ),
      ),
    );
  }
}

List<Game> generateGames() {
  return [
    Game(
      name: 'Game 1',
      description: 'Description of Game 1',
      imageUrl: 'https://urlz.fr/qJyi',
    ),
    Game(
      name: 'Game 2',
      description: 'Description of Game 2',
      imageUrl: 'https://urlz.fr/qJyg',
    ),
    // Add more games here
  ];
}

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Add rounded corners
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameDetailPage(game: game)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
                child: Image.network(
                  game.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    game.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
