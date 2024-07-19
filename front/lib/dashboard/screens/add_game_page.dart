import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/l10n/app_localizations.dart';

import 'package:uresport/core/services/cache_service.dart';

class AddGamePage extends StatefulWidget {
  const AddGamePage({super.key});

  @override
  AddGamePageState createState() => AddGamePageState();
}

class AddGamePageState extends State<AddGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _tagsController = TextEditingController();
  final Dio _dio = Dio();
  final CacheService _cacheService = CacheService.instance;

  Future<void> _saveGame() async {
    AppLocalizations l = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
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

      // Log des données envoyées
      if (kDebugMode) {
        print('Sending data: $newGame');
      }

      try {
        final token = await _cacheService.getString('token');
        if (token == null) throw Exception('No token found');
        final response = await _dio.post(
          'http://localhost:8080/games/',
          data: newGame,
          options: Options(headers: {
            'Authorization': token,
          }),
        );

        // Log de la réponse complète du serveur
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response data: ${response.data}');
        }

        if (response.statusCode == 201) {
          if (!mounted) return;
          BlocProvider.of<DashboardBloc>(context).add(FetchGames());
          if (!mounted) return;
          Navigator.of(context).pop(true);
          _showAlertDialog(l.gameAdded);
        } else {
          _showAlertDialog('${l.errorAddingGame}: ${response.statusMessage}');
        }
      } catch (e) {
        // Log de l'exception complète
        if (kDebugMode) {
          print('Exception: $e');
        }
        _showAlertDialog('${l.errorAddingGame}: $e');
      }
    }
  }

  void _showAlertDialog(String message) {
    AppLocalizations l = AppLocalizations.of(context);
    if (kDebugMode) {
      print(message);
    } // Afficher le message dans la console
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.gameAdded),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.ok),
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
    AppLocalizations l = AppLocalizations.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.addGame, style: const TextStyle(fontSize: 24)),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: l.name),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l.pleaseEnterGameName;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: l.description),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l.pleaseEnterGameDescription;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _imageController,
                      decoration: InputDecoration(labelText: l.imageUrl),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l.pleaseEnterImageUrl;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _tagsController,
                      decoration: InputDecoration(labelText: l.tags),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l.pleaseEnterTags;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l.cancel),
                ),
                ElevatedButton(
                  onPressed: _saveGame,
                  child: Text(l.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
