import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/widgets/custom_toast.dart';

class EditTournamentScreen extends StatefulWidget {
  final Tournament tournament;

  const EditTournamentScreen({super.key, required this.tournament});

  @override
  EditTournamentScreenState createState() => EditTournamentScreenState();
}

class EditTournamentScreenState extends State<EditTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _locationController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _imageController;
  late TextEditingController _gameIdController;
  late TextEditingController _nbPlayerController;
  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tournament.name);
    _descriptionController =
        TextEditingController(text: widget.tournament.description);
    _startDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.tournament.startDate));
    _endDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.tournament.endDate));
    _locationController =
        TextEditingController(text: widget.tournament.location);
    _latitudeController =
        TextEditingController(text: widget.tournament.latitude.toString());
    _longitudeController =
        TextEditingController(text: widget.tournament.longitude.toString());
    _imageController = TextEditingController(text: widget.tournament.image);
    _gameIdController =
        TextEditingController(text: widget.tournament.game.id.toString());
    _nbPlayerController =
        TextEditingController(text: widget.tournament.nbPlayers.toString());
    _isPrivate = widget.tournament.isPrivate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _locationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageController.dispose();
    _gameIdController.dispose();
    _nbPlayerController.dispose();
    super.dispose();
  }

  void showNotificationToast(BuildContext context, String message,
      {Color? backgroundColor, Color? textColor}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomToast(
        message: message,
        backgroundColor: backgroundColor ?? Colors.blue,
        textColor: textColor ?? Colors.white,
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

  Future<void> _saveTournament() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'");
      final startDate =
          dateFormat.format(DateTime.parse(_startDateController.text));
      final endDate =
          dateFormat.format(DateTime.parse(_endDateController.text));
      final location = _locationController.text;
      final latitude = double.parse(_latitudeController.text);
      final longitude = double.parse(_longitudeController.text);
      final image = _imageController.text;
      final isPrivate = _isPrivate;
      final gameId = int.parse(_gameIdController.text);
      final nbPlayers = int.parse(_nbPlayerController.text);

      final updatedTournament = widget.tournament.copyWith(
        name: name,
        description: description,
        startDate: DateTime.parse(startDate),
        endDate: DateTime.parse(endDate),
        location: location,
        latitude: latitude,
        longitude: longitude,
        image: image,
        isPrivate: isPrivate,
        game: widget.tournament.game.copyWith(id: gameId),
        nbPlayers: nbPlayers,
      );

      final tournamentJson = updatedTournament.toJson();
      debugPrint('Tournament JSON: ${jsonEncode(tournamentJson)}');

      final tournamentService =
          Provider.of<ITournamentService>(context, listen: false);
      try {
        await tournamentService.updateTournament(updatedTournament);
        if (!mounted) return;
        showNotificationToast(context, 'Tournament updated successfully',
            backgroundColor: Colors.green);
        Navigator.pop(context, updatedTournament);
      } catch (e) {
        showNotificationToast(context, 'Failed to update tournament: $e',
            backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tournament'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTournament,
          ),
        ],
      ),
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
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: 'Start Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(labelText: 'End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an end date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a longitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
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
              TextFormField(
                controller: _gameIdController,
                decoration: const InputDecoration(labelText: 'Game ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a game ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nbPlayerController,
                decoration:
                    const InputDecoration(labelText: 'Number of Players'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of players';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTournament,
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
