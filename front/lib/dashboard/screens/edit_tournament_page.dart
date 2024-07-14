import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/tournament.dart';

import '../../core/models/game.dart';

class EditTournamentPage extends StatefulWidget {
  final Tournament? tournament;

  const EditTournamentPage({Key? key, this.tournament}) : super(key: key);

  @override
  _EditTournamentPageState createState() => _EditTournamentPageState();
}

class _EditTournamentPageState extends State<EditTournamentPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController locationController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController ownerIdController;
  late TextEditingController imageController;
  late TextEditingController privateController;
  late TextEditingController nbPlayerController;
  late TextEditingController upvotesController;

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.tournament?.name ?? '');
    descriptionController = TextEditingController(text: widget.tournament?.description ?? '');
    startDateController = TextEditingController(text: widget.tournament?.startDate.toIso8601String() ?? '');
    endDateController = TextEditingController(text: widget.tournament?.endDate.toIso8601String() ?? '');
    locationController = TextEditingController(text: widget.tournament?.location ?? '');
    latitudeController = TextEditingController(text: widget.tournament?.latitude.toString() ?? '');
    longitudeController = TextEditingController(text: widget.tournament?.longitude.toString() ?? '');
    ownerIdController = TextEditingController(text: widget.tournament?.ownerId.toString() ?? '');
    imageController = TextEditingController(text: widget.tournament?.image ?? '');
    privateController = TextEditingController(text: widget.tournament?.isPrivate.toString() ?? '');
    nbPlayerController = TextEditingController(text: widget.tournament?.teams.length.toString() ?? '');
    upvotesController = TextEditingController(text: widget.tournament?.upvotes.toString() ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
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
      // Edit existing tournament
      final updatedTournament = Tournament(
        id: widget.tournament!.id,
        name: nameController.text,
        description: descriptionController.text,
        startDate: DateTime.parse(startDateController.text),
        endDate: DateTime.parse(endDateController.text),
        location: locationController.text,
        latitude: double.parse(latitudeController.text),
        longitude: double.parse(longitudeController.text),
        ownerId: int.parse(ownerIdController.text),
        image: imageController.text,
        isPrivate: privateController.text.toLowerCase() == 'true',
        owner: widget.tournament!.owner,
        teams: widget.tournament!.teams,
        upvotes: int.parse(upvotesController.text),
        game: widget.tournament!.game,
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
            SnackBar(content: Text('Failed to update tournament: ${response.statusMessage}')),
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
        title: Text(widget.tournament == null ? 'Add Tournament' : 'Edit Tournament'),
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
                controller: startDateController,
                decoration: const InputDecoration(labelText: 'Start Date'),
              ),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(labelText: 'End Date'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
              ),
              TextField(
                controller: longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
              TextField(
                controller: ownerIdController,
                decoration: const InputDecoration(labelText: 'Owner ID'),
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
              TextField(
                controller: upvotesController,
                decoration: const InputDecoration(labelText: 'Upvotes'),
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
