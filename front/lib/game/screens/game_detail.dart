import 'package:flutter/material.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/shared/utils/filter_button.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;

  const GameDetailPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(game.name),
                    content: Text(game.description),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Image.network(game.imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tournaments',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: game.tournaments.length,
              itemBuilder: (context, index) {
                final tournament = game.tournaments[index];
                return ListTile(
                  title: Text(tournament.name),
                  subtitle: Text(tournament.description),
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.favorite_border),
              label: const Text('Follow'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Follow Game'),
                      content: const Text('Do you want to follow this game?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement follow logic here
                            Navigator.pop(context);
                          },
                          child: const Text('Follow'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const FilterButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
