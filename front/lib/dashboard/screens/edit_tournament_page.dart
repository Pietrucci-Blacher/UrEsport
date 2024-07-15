import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:uresport/core/models/tournament.dart';

class EditTournamentPage extends StatefulWidget {
  final Tournament? tournament;

  const EditTournamentPage({Key? key, this.tournament}) : super(key: key);

  @override
  _EditTournamentPageState createState() => _EditTournamentPageState();
}

class _EditTournamentPageState extends State<EditTournamentPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController ownerIdController;
  late TextEditingController imageController;
  late TextEditingController privateController;
  late TextEditingController nbPlayerController;
  late TextEditingController upvotesController;

  final Dio _dio = Dio();
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.tournament?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.tournament?.description ?? '');
    _startDateTime = widget.tournament?.startDate;
    _endDateTime = widget.tournament?.endDate;
    locationController =
        TextEditingController(text: widget.tournament?.location ?? '');
    latitudeController = TextEditingController(
        text: widget.tournament?.latitude.toString() ?? '');
    longitudeController = TextEditingController(
        text: widget.tournament?.longitude.toString() ?? '');
    ownerIdController = TextEditingController(
        text: widget.tournament?.ownerId.toString() ?? '');
    imageController =
        TextEditingController(text: widget.tournament?.image ?? '');
    privateController = TextEditingController(
        text: widget.tournament?.isPrivate.toString() ?? '');
    nbPlayerController = TextEditingController(
        text: widget.tournament?.nbPlayer.toString() ?? '');
    upvotesController = TextEditingController(
        text: widget.tournament?.upvotes.toString() ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    ownerIdController.dispose();
    imageController.dispose();
    privateController.dispose();
    nbPlayerController.dispose();
    upvotesController.dispose();
    super.dispose();
  }

  Future<void> _saveTournament() async {
    if (widget.tournament == null) {
      // Add new tournament logic
      // Implement your own logic for adding a new tournament
    } else {
      final updatedTournament = Tournament(
        id: widget.tournament!.id,
        name: nameController.text,
        description: descriptionController.text,
        startDate: _startDateTime!,
        endDate: _endDateTime!,
        location: locationController.text,
        latitude: double.tryParse(latitudeController.text) ?? 0,
        longitude: double.tryParse(longitudeController.text) ?? 0,
        ownerId: int.parse(ownerIdController.text),
        image: imageController.text,
        isPrivate: privateController.text.toLowerCase() == 'true',
        owner: widget.tournament!.owner,
        nbPlayer: int.parse(nbPlayerController.text),
        upvotes: int.parse(upvotesController.text),
        game: widget.tournament!.game,
        teams: [],
      );

      try {
        final response = await _dio.patch(
          '${dotenv.env['API_ENDPOINT']}/tournaments/${updatedTournament.id}',
          data: updatedTournament.toJson(),
        );

        if (response.statusCode == 200) {
          // Successfully updated the tournament
          Navigator.of(context).pop(updatedTournament);
        } else {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to update tournament: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update tournament: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.tournament == null ? 'Add Tournament' : 'Edit Tournament'),
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
              DateTimeField(
                format: _dateFormat,
                initialValue: _startDateTime,
                decoration:
                    const InputDecoration(labelText: 'Start Date & Time'),
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
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
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
                initialValue: _endDateTime,
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
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
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
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image'),
              ),
              TextField(
                controller: privateController,
                decoration: const InputDecoration(labelText: 'Private'),
              ),
              TextField(
                controller: nbPlayerController,
                decoration: const InputDecoration(labelText: 'Nb Players'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTournament,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
