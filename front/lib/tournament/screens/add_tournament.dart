import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/widgets/custom_toast.dart';

class AddTournamentPage extends StatefulWidget {
  const AddTournamentPage({super.key});

  @override
  AddTournamentPageState createState() => AddTournamentPageState();
}

class AddTournamentPageState extends State<AddTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _gameIdController = TextEditingController();
  final TextEditingController _nbPlayerController = TextEditingController();
  bool _isPrivate = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final tournamentData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'start_date': _startDateController.text,
        'end_date': _endDateController.text,
        'location': _locationController.text,
        'latitude': _latitudeController.text.isEmpty
            ? null
            : double.tryParse(_latitudeController.text),
        'longitude': _longitudeController.text.isEmpty
            ? null
            : double.tryParse(_longitudeController.text),
        'private': _isPrivate,
        'game_id': int.tryParse(_gameIdController.text),
        'nb_player': int.tryParse(_nbPlayerController.text),
      };

      try {
        final tournamentService =
            Provider.of<ITournamentService>(context, listen: false);
        await tournamentService.createTournament(tournamentData);
        showCustomToast('Tournoi créé avec succès', Colors.green);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        showCustomToast(
            'Erreur lors de la création du tournoi: $e', Colors.red);
      }
    }
  }

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final DateTime fullDateTime = DateTime(
            picked.year, picked.month, picked.day, time.hour, time.minute);
        final formattedDate =
            DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(fullDateTime.toUtc());
        setState(() {
          controller.text = formattedDate;
        });
      }
    }
  }

  void showCustomToast(String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomToast(
        message: message,
        backgroundColor: backgroundColor,
        onClose: () {
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Tournament')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: 'Start Date'),
                readOnly: true,
                onTap: () => _selectDateTime(context, _startDateController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Start Date is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(labelText: 'End Date'),
                readOnly: true,
                onTap: () => _selectDateTime(context, _endDateController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'End Date is required';
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
                controller: _gameIdController,
                decoration: const InputDecoration(labelText: 'Game ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Game ID is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nbPlayerController,
                decoration: const InputDecoration(
                    labelText: 'Number of Players per Team'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Number of Players is required';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Private'),
                value: _isPrivate,
                onChanged: (bool value) {
                  setState(() {
                    _isPrivate = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Tournament'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
