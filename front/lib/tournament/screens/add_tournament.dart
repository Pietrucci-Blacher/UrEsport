import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/l10n/app_localizations.dart';
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
        if (!mounted) return;
        showCustomToast(
            AppLocalizations.of(context).tournamentCreatedSuccessfully,
            Colors.green);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        showCustomToast(
            AppLocalizations.of(context).failedToCreateTournament(e.toString()),
            Colors.red);
      }
    }
  }

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller) async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && context.mounted) {
      TimeOfDay? pickedTime;
      if (pickedDate.isSameDateAs(now)) {
        pickedTime = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(now.add(const Duration(minutes: 1))),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
      } else {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 0, minute: 0),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
      }

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
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
    AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.addTournament)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l.name),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.nameIsRequired;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: l.description),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.descriptionIsRequired;
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
                    return l.startDateIsRequired;
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
                    return l.endDateIsRequired;
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
                decoration: InputDecoration(labelText: l.latitude),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: l.longitude),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _gameIdController,
                decoration: InputDecoration(labelText: l.gameId),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.gameIdIsRequired;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nbPlayerController,
                decoration:
                    InputDecoration(labelText: l.numberOfPlayersPerTeam),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.numberOfPlayersIsRequired;
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text(l.private),
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
                child: Text(l.createTournament),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
