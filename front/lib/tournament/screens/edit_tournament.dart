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
    _gameIdController =
        TextEditingController(text: widget.tournament.game.id.toString());
    _nbPlayerController =
        TextEditingController(text: widget.tournament.nbPlayers.toString());
    _isPrivate = widget.tournament.isPrivate;
    _selectedGameId = widget.tournament.game.id;
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
      if(!mounted) return;
      _showToast(context, '${AppLocalizations.of(context).failedToLoadGames} $e', Colors.red);
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

  Future<void> _saveTournament() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'");
      final startDate = dateFormat.format(DateTime.parse(_startDateController.text));
      final endDate = dateFormat.format(DateTime.parse(_endDateController.text));
      final location = _locationController.text.isNotEmpty ? _locationController.text : '';
      final latitude = _latitudeController.text.isNotEmpty ? double.parse(_latitudeController.text) : 0.0;
      final longitude = _longitudeController.text.isNotEmpty ? double.parse(_longitudeController.text) : 0.0;
      final isPrivate = _isPrivate;
      final gameId = _selectedGameId;
      final nbPlayers = int.parse(_nbPlayerController.text);

      final updatedTournament = widget.tournament.copyWith(
        name: name,
        description: description,
        startDate: DateTime.parse(startDate),
        endDate: DateTime.parse(endDate),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.pleaseEnterEndDate;
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
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: l.longitude),
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
