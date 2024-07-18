import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:uresport/l10n/app_localizations.dart';

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
        if(!mounted) return;
        showCustomToast(AppLocalizations.of(context).tournamentCreatedSuccessfully, Colors.green);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        showCustomToast(
            AppLocalizations.of(context).failedToCreateTournament(e.toString()), Colors.red);
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
    if (picked != null && context.mounted) {
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
                decoration: InputDecoration(labelText: l.startDate.toString()),
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
                decoration: InputDecoration(labelText: l.endDate.toString()),
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
                decoration: InputDecoration(labelText: l.location.toString()),
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
                decoration: InputDecoration(labelText: l.numberOfPlayersPerTeam),
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
