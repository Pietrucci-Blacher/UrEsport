import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/core/models/game.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  late TextEditingController _gameIdController;
  late TextEditingController _nbPlayerController;
  bool _isPrivate = false;
  List<Game> _games = [];
  int? _selectedGameId;
  String? _storedStartDate;
  String? _storedEndDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tournament.name);
    _descriptionController =
        TextEditingController(text: widget.tournament.description);
    _startDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd HH:mm').format(widget.tournament.startDate));
    _endDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd HH:mm').format(widget.tournament.endDate));
    _locationController =
        TextEditingController(text: widget.tournament.location);
    _latitudeController =
        TextEditingController(text: widget.tournament.latitude.toString());
    _longitudeController =
        TextEditingController(text: widget.tournament.longitude.toString());
    _gameIdController =
        TextEditingController(text: widget.tournament.game.id.toString());
    _nbPlayerController =
        TextEditingController(text: widget.tournament.nbPlayers.toString());
    _isPrivate = widget.tournament.isPrivate;
    _selectedGameId = widget.tournament.game.id;
    _storedStartDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
        .format(widget.tournament.startDate.toUtc());
    _storedEndDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
        .format(widget.tournament.endDate.toUtc());
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
      if (!context.mounted) return;
      debugPrint('Failed to load games: $e');
      if (!mounted) return;
      _showToast(context,
          '${AppLocalizations.of(context).failedToLoadGames} $e', Colors.red);
    }
  }

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller, bool isStartDate) async {
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
        final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(fullDateTime.toUtc());
        final displayDate = DateFormat("yyyy-MM-dd HH:mm").format(fullDateTime);
        setState(() {
          controller.text = displayDate; // Display format
          if (isStartDate) {
            _storedStartDate = formattedDate; // Store for backend use
          } else {
            _storedEndDate = formattedDate; // Store for backend use
          }
        });
      }
    }
  }

  Future<void> _saveTournament() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final location = _locationController.text;
      final latitude = _latitudeController.text.isNotEmpty
          ? double.parse(_latitudeController.text)
          : 0.0;
      final longitude = _longitudeController.text.isNotEmpty
          ? double.parse(_longitudeController.text)
          : 0.0;
      final isPrivate = _isPrivate;
      final gameId = _selectedGameId;
      final nbPlayers = int.parse(_nbPlayerController.text);

      final updatedTournament = widget.tournament.copyWith(
        name: name,
        description: description,
        startDate: DateTime.parse(_storedStartDate!),
        endDate: DateTime.parse(_storedEndDate!),
        location: location,
        latitude: latitude,
        longitude: longitude,
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
        _showToast(
            context,
            AppLocalizations.of(context).tournamentUpdatedSuccessfully,
            Colors.green);
        Navigator.pop(context, updatedTournament);
      } catch (e) {
        debugPrint('Failed to update tournament: $e');
        _showToast(context,
            AppLocalizations.of(context).failedToUpdateTournament, Colors.red);
      }
    }
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
    _gameIdController.dispose();
    _nbPlayerController.dispose();
    super.dispose();
  }

  void _showToast(BuildContext context, String message, Color backgroundColor) {
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
      appBar: AppBar(
        title: Text(l.editTournament),
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
                decoration: InputDecoration(labelText: l.name),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.pleaseEnterName;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: l.description),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.pleaseEnterDescription;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: l.startDateText),
                readOnly: true,
                onTap: () => _selectDateTime(context, _startDateController, true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.pleaseEnterStartDate;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: l.endDateText),
                readOnly: true,
                onTap: () => _selectDateTime(context, _endDateController, false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.pleaseEnterEndDate;
                  }
                  return null;
                },
              ),
              GooglePlacesAutoCompleteTextFormField(
                textEditingController: _locationController,
                googleAPIKey: dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '',
                decoration: InputDecoration(labelText: l.location),
                debounceTime: 800,
                countries: const [],
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (prediction) {
                  setState(() {
                    _latitudeController.text = prediction.lat.toString();
                    _longitudeController.text = prediction.lng.toString();
                  });
                },
                itmClick: (prediction) {
                  _locationController.text = prediction.description ?? '';
                  _locationController.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description?.length ?? 0));
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: l.latitude,
                  enabled: false,
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                readOnly: true,
                focusNode: AlwaysDisabledFocusNode(),
              ),
              TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(
                    labelText: l.longitude,
                    enabled: false,
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  focusNode: AlwaysDisabledFocusNode()
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
                  value: _selectedGameId,
                  validator: (value) {
                    if (value == null) {
                      return l.pleaseEnterGameId;
                    }
                    return null;
                  },
                )
              else
                const Center(child: CircularProgressIndicator()),
              TextFormField(
                controller: _nbPlayerController,
                decoration: InputDecoration(labelText: l.numberOfPlayers),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.pleaseEnterNumberOfPlayers;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTournament,
                child: Text(l.validate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension pour désactiver le focus sur un TextFormField
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

extension DateOnlyCompare on DateTime {
  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
