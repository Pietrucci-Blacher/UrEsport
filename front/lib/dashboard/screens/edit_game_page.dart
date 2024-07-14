import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/game.dart';

class EditGamePage extends StatefulWidget {
  final Game? game;

  const EditGamePage({super.key, this.game});

  @override
  _EditGamePageState createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController imageUrlController;
  late TextEditingController tagsController;

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.game?.name ?? '');
    descriptionController = TextEditingController(text: widget.game?.description ?? '');
    imageUrlController = TextEditingController(text: widget.game?.imageUrl ?? '');
    tagsController = TextEditingController(text: widget.game?.tags.join(', ') ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Future<void> _saveGame() async {
    if (widget.game == null) {
      // Add new game logic
      // Implement your own logic for adding a new game
    } else {
      // Edit existing game
      final updatedGame = Game(
        id: widget.game!.id,
        name: nameController.text,
        description: descriptionController.text,
        imageUrl: imageUrlController.text,
        tags: tagsController.text.split(', ').toList(),
        createdAt: widget.game!.createdAt,
        updatedAt: DateTime.now().toString(),
      );

      try {
        final response = await _dio.patch(
          '${dotenv.env['API_ENDPOINT']}/games/${updatedGame.id}',
          data: updatedGame.toJson(),
        );

        if (response.statusCode == 200) {
          // Successfully updated the game
          Navigator.of(context).pop(true);  // Return true to indicate success
        } else {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update game: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update game: $e')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game == null ? 'Add Game' : 'Edit Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(labelText: 'Tags'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGame,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
