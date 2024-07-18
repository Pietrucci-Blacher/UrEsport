import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uresport/core/models/tournament.dart';

class EditTournamentPage extends StatefulWidget {
  final Tournament? tournament;

  const EditTournamentPage({super.key, this.tournament});

  @override
  EditTournamentPageState createState() => EditTournamentPageState();
}

class EditTournamentPageState extends State<EditTournamentPage> {
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
        text: widget.tournament?.nbPlayers.toString() ?? '');
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
        nbPlayers: int.parse(nbPlayerController.text),
        upvotes: int.parse(upvotesController.text),
        game: widget.tournament!.game,
        teams: [],
      );

      try {
        final response = await _dio.patch(
          '${dotenv.env['API_ENDPOINT']}/tournaments/${updatedTournament.id}',
          data: updatedTournament.toJson(),
        );
        if (!mounted) return;
        if (response.statusCode == 200) {
          if (mounted) {
            Navigator.of(context).pop(updatedTournament);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Failed to update tournament: ${response.statusMessage}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update tournament: $e')),
          );
        }
      }
    }
  }

  void _selectStartDate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 350,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  _startDateTime = args.value;
                });
                Navigator.pop(context);
              },
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: _startDateTime ?? DateTime.now(),
            ),
          ),
        );
      },
    );
  }

  void _selectEndDate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 350,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  _endDateTime = args.value;
                });
                Navigator.pop(context);
              },
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: _endDateTime ?? DateTime.now(),
            ),
          ),
        );
      },
    );
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
              GestureDetector(
                onTap: () => _selectStartDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Start Date & Time',
                      hintText: _startDateTime != null
                          ? _dateFormat.format(_startDateTime!)
                          : '',
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectEndDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'End Date & Time',
                      hintText: _endDateTime != null
                          ? _dateFormat.format(_endDateTime!)
                          : '',
                    ),
                  ),
                ),
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
