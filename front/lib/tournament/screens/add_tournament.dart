import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/tournament/bloc/tournament_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
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
  final TextEditingController _nbPlayerController = TextEditingController();
  bool _isPrivate = false;
  int? _selectedGameId;
  List<Game> _games = [];
  String?
      _storedStartDate; // Variable to store the formatted start date for backend
  String?
      _storedEndDate; // Variable to store the formatted end date for backend

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
      if (!mounted) return;
      showCustomToast(
          '${AppLocalizations.of(context).failedToLoadGames}: $e ', Colors.red);
    }
  }

  Future<void> _selectDateTime(BuildContext context,
      TextEditingController controller, bool isStartDate) async {
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
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(fullDateTime.toUtc());
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final tournamentData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'start_date': _storedStartDate,
        'end_date': _storedEndDate,
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
        final newTournament =
            await tournamentService.createTournament(tournamentData);

        if (!mounted) return;

        BlocProvider.of<TournamentBloc>(context, listen: false)
            .add(TournamentAdded(newTournament));

        showCustomToast(
            AppLocalizations.of(context).tournamentCreatedSuccessfully,
            Colors.green);

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        showCustomToast(
            AppLocalizations.of(context).failedToCreateTournament, Colors.red);
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
                onTap: () =>
                    _selectDateTime(context, _startDateController, true),
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
                onTap: () =>
                    _selectDateTime(context, _endDateController, false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.endDateIsRequired;
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
                      TextPosition(
                          offset: prediction.description?.length ?? 0));
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
                  focusNode: AlwaysDisabledFocusNode()),
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
