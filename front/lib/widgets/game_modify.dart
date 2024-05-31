import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uresport/core/models/game.dart';

class GameModify extends StatefulWidget {
  final Game game;
  final bool isEdit;

  const GameModify({
    super.key,
    required this.game,
    required this.isEdit,
  });

  @override
  GameModifyState createState() => GameModifyState();
}

class GameModifyState extends State<GameModify> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;

  String? _updateUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.game.name);
    _descriptionController = TextEditingController(text: widget.game.description);
    _urlController = TextEditingController(text: widget.game.imageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _updateGame() async {
    if (_formKey.currentState!.validate()) {
      final url = 'http://10.0.2.2:8080/games/${widget.game.id}';
      setState(() {
        _updateUrl = url;
      });

      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      try {
        final response = await http.patch(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': _nameController.text,
            'description': _descriptionController.text,
            'imageUrl': _urlController.text,
          }),
        );

        if (response.statusCode == 200) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Game updated successfully')),
          );
          navigator.pushReplacementNamed('/games');
        } else {
          messenger.showSnackBar(
            SnackBar(content: Text('Failed to update game: ${response.body} (status: ${response.statusCode})')),
          );
        }
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour du jeu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Modifier le jeu' : 'Ajouter un jeu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'URL de l\'image'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une URL d\'image';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateGame,
                child: const Text('Enregistrer'),
              ),
              const SizedBox(height: 20),
              if (_updateUrl != null)
                Text('URL de mise à jour: $_updateUrl'),
              Text('ID du jeu: ${widget.game.id}'),
              Text('Route: ${widget.isEdit ? 'PUT' : 'POST'} /games/${widget.game.id}'),
              Text('Response code: ${widget.isEdit ? '200' : '201'}'),
            ],
          ),
        ),
      ),
    );
  }
}
