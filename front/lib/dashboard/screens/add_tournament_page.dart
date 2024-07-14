import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';

class AddTournamentPage extends StatefulWidget {
  const AddTournamentPage({super.key});

  @override
  _AddTournamentPageState createState() => _AddTournamentPageState();
}

class _AddTournamentPageState extends State<AddTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _imageController = TextEditingController();
  final _privateController = TextEditingController();
  final _gameIdController = TextEditingController();
  final _nbPlayerController = TextEditingController();
  final Dio _dio = Dio();

  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  String _formatDateToUtcWithoutMilliseconds(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dateTime.toUtc());
  }

  Future<void> _saveTournament() async {
    if (_formKey.currentState!.validate() && _startDateTime != null && _endDateTime != null) {
      final newTournament = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'start_date': _formatDateToUtcWithoutMilliseconds(_startDateTime!),
        'end_date': _formatDateToUtcWithoutMilliseconds(_endDateTime!),
        'location': _locationController.text.isNotEmpty ? _locationController.text : null,
        'latitude': _latitudeController.text.isNotEmpty ? double.tryParse(_latitudeController.text) : null,
        'longitude': _longitudeController.text.isNotEmpty ? double.tryParse(_longitudeController.text) : null,
        'private': _privateController.text.toLowerCase() == 'true',
        'game_id': int.tryParse(_gameIdController.text) ?? 0,
        'nb_player': int.tryParse(_nbPlayerController.text) ?? 0,
      };

      // Log des données envoyées
      if (kDebugMode) {
        print('Sending data: $newTournament');
      }

      try {
        final response = await _dio.post(
          '${dotenv.env['API_ENDPOINT']}/tournaments',
          data: newTournament,
        );

        // Log de la réponse complète du serveur
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response data: ${response.data}');
        }

        if (response.statusCode == 201) {
          BlocProvider.of<DashboardBloc>(context).add(FetchTournaments());
          Navigator.of(context).pop(true);
          _showAlertDialog('Tournoi ajouté');
        } else {
          _showAlertDialog('Erreur ajout du tournoi: ${response.statusMessage}');
        }
      } catch (e) {
        // Log de l'exception complète
        if (kDebugMode) {
          print('Exception: $e');
        }
        _showAlertDialog('Erreur ajout du tournoi: $e');
      }
    } else {
      _showAlertDialog('Please fill in all required fields and select dates and times');
    }
  }

  void _showAlertDialog(String message) {
    if (kDebugMode) {
      print(message);
    } // Afficher le message dans la console
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
    _locationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageController.dispose();
    _privateController.dispose();
    _gameIdController.dispose();
    _nbPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Tournament', style: TextStyle(fontSize: 24)),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the tournament name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the tournament description';
                        }
                        return null;
                      },
                    ),
                    DateTimeField(
                      format: _dateFormat,
                      decoration: const InputDecoration(labelText: 'Start Date & Time'),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onChanged: (date) => setState(() {
                        _startDateTime = date;
                      }),
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the start date and time';
                        }
                        return null;
                      },
                    ),
                    DateTimeField(
                      format: _dateFormat,
                      decoration: const InputDecoration(labelText: 'End Date & Time'),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onChanged: (date) => setState(() {
                        _endDateTime = date;
                      }),
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the end date and time';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _privateController,
                      decoration: const InputDecoration(labelText: 'Private (true/false)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter if the tournament is private';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _gameIdController,
                      decoration: const InputDecoration(labelText: 'Game ID'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the game ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nbPlayerController,
                      decoration: const InputDecoration(labelText: 'Number of Players'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of players';
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _saveTournament,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
