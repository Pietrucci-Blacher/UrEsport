import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/tournament/screens/tournament_particip.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:uresport/widgets/rating.dart';

import '../../core/models/user.dart';

class TournamentDetailsScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentDetailsScreen({super.key, required this.tournament});

  @override
  _TournamentDetailsScreenState createState() => _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
  bool _hasJoined = false;
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkIfJoined();
    _loadCurrentUser();
  }

  Future<void> _checkIfJoined() async {
    final tournamentService = Provider.of<ITournamentService>(context, listen: false);
    try {
      final hasJoined = await tournamentService.hasJoinedTournament(widget.tournament.id, 'username'); // Remplacez 'username' par l'ID ou le nom d'utilisateur réel
      setState(() {
        _hasJoined = hasJoined;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if joined: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<IAuthService>(context, listen: false);
    try {
      final user = await authService.getUser();
      setState(() {
        _currentUser = user;
        print('User loaded: $_currentUser'); // Ajoutez ce log
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading current user: $e');
      }
    }
  }

  void showNotificationToast(BuildContext context, String message, {Color? backgroundColor, Color? textColor}) {
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

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tournament.name),
      ),
      body: _isLoading || _currentUser == null // Ajoutez cette condition
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'tournamentHero${widget.tournament.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    widget.tournament.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.tournament.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                widget.tournament.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${widget.tournament.location}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Start Date: ${dateFormat.format(widget.tournament.startDate)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'End Date: ${dateFormat.format(widget.tournament.endDate)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upvotes:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        // Utiliser le widget personnalisé
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Participants:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Column(
                          children: List.generate(5, (index) {
                            if (index < widget.tournament.teams.length) {
                              final team = widget.tournament.teams[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.blueAccent,
                                      child: Text(
                                        team.name[0],
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      team.name,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.person, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Participant ${index + 1}',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TournamentParticipantsScreen(tournament: widget.tournament),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Voir tous les participants',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor, // Couleur du texte cliquable
                                  decoration: TextDecoration.underline, // Souligner le texte
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).primaryColor, // Couleur de l'icône
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!_hasJoined)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.tournament.isPrivate) {
                        _sendJoinRequest(context, widget.tournament.id, 1); // Remplacez 1 par l'ID de l'équipe réelle
                      } else {
                        _joinTournament(context, widget.tournament.id, 1); // Remplacez 1 par l'ID de l'équipe réelle
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(widget.tournament.isPrivate ? 'Envoyer demande pour rejoindre' : 'Rejoindre le tournoi'),
                  ),
                ),
              const SizedBox(height: 16),
              RatingWidget(
                tournamentId: widget.tournament.id, // Utilisation correcte de l'ID de tournoi
                showCustomToast: showNotificationToast,
                userId: _currentUser?.id ?? 0, // Utilisation correcte de l'ID de l'utilisateur
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _joinTournament(BuildContext context, int tournamentId, int teamId) async {
    final tournamentService = Provider.of<ITournamentService>(context, listen: false);

    try {
      await tournamentService.joinTournament(tournamentId, teamId);
      showNotificationToast(context, 'Vous avez bien rejoint le tournoi', backgroundColor: Colors.green);
      setState(() {
        _hasJoined = true;
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response?.data != null) {
          final errorMessage = e.response?.data['error'];
          if (errorMessage == 'Team already in this tournament') {
            showNotificationToast(context, 'Vous avez déjà rejoint le tournoi', backgroundColor: Colors.red);
            setState(() {
              _hasJoined = true;
            });
          } else {
            showNotificationToast(context, 'Erreur lors du join: $errorMessage', backgroundColor: Colors.red);
          }
        } else {
          showNotificationToast(context, 'Erreur lors du join: ${e.message}', backgroundColor: Colors.red);
        }
      } else {
        showNotificationToast(context, 'Erreur pour rejoindre le tournoi', backgroundColor: Colors.red);
      }
    }
  }

  Future<void> _sendJoinRequest(BuildContext context, int tournamentId, int teamId) async {
    showNotificationToast(context, 'Demande pour rejoindre envoyée', backgroundColor: Colors.orange);
  }
}
