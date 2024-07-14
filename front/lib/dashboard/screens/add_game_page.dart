import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';

class AddGamePage extends StatefulWidget {
  const AddGamePage({Key? key}) : super(key: key);

  @override
  _AddGamePageState createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _tagsController = TextEditingController();
  final Dio _dio = Dio();

  Future<void> _saveGame() async {
    if (_formKey.currentState!.validate()) {
      // Utiliser une expression régulière pour extraire les tags
      final tags = _tagsController.text
          .split(RegExp(r'[\s,]+'))
          .where((tag) => tag.isNotEmpty)
          .toList();

      final newGame = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'image': _imageController.text,
        'tags': tags,
      };

      try {
        final response = await _dio.post(
          'http://localhost:8080/games',
          data: newGame,
        );

        if (response.statusCode == 201) {
          BlocProvider.of<DashboardBloc>(context).add(FetchGames());
          Navigator.of(context).pop(true);
          _showAlertDialog('Jeux ajouté');
        } else {
          _showAlertDialog('Erreur ajout du jeux: ${response.statusMessage}');
        }
      } catch (e) {
        _showAlertDialog('Erreur ajout du jeux: $e');
      }
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Game'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the game name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the game description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(labelText: 'Tags (comma or space separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the tags';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveGame,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
