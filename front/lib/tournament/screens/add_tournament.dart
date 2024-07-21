import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:uresport/core/models/game.dart';

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
  final TextEditingController _nbPlayerController = TextEditingController();
  bool _isPrivate = false;
  int? _selectedGameId;
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    try {
      final gameService = Provider.of<IGameService>(context, listen: false);
      final games = await gameService.fetchGames();
      setState(() {
        _games = games;
      });
      debugPrint('Games loaded: ${_games.length}');
    } catch (e) {
      debugPrint('Failed to load games: $e');
      showCustomToast(
          '${AppLocalizations.of(context).failedToLoadGames}: $e ', Colors.red);
    }
  }

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
        'game_id': _selectedGameId,
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
            AppLocalizations.of(context).failedToCreateTournament,
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
                decoration: InputDecoration(labelText: l.locationText),
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
              if (_games.isNotEmpty)
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: l.gameId),
                  items: _games.map((Game game) {
                    return DropdownMenuItem<int>(
                      value: game.id,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.network(
                              game.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(game.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedGameId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return l.gameIdIsRequired;
                    }
                    return null;
                  },
                )
              else
                const Center(child: CircularProgressIndicator()),
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

extension DateOnlyCompare on DateTime {
  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
