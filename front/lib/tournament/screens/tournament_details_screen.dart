import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/tournament/screens/tournament_particip.dart';

class TournamentDetailsScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentDetailsScreen({super.key, required this.tournament});

  @override
  _TournamentDetailsScreenState createState() => _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
  bool _hasJoined = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfJoined();
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

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tournament.name),
      ),
      body: _isLoading
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
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
                        UpvoteButton(tournament: widget.tournament), // Utiliser le widget personnalisé
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _joinTournament(BuildContext context, int tournamentId, int teamId) async {
    final tournamentService = Provider.of<ITournamentService>(context, listen: false);

    try {
      // Appelez la méthode joinTournament du service
      await tournamentService.joinTournament(tournamentId, teamId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous avez bien rejoint le tournoi')),
      );
      setState(() {
        _hasJoined = true;
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response?.data != null) {
          final errorMessage = e.response?.data['error'];
          if (errorMessage == 'Team already in this tournament') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vous avez déjà rejoint le tournoi')),
            );
            setState(() {
              _hasJoined = true;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors du join: $errorMessage')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors du join: ${e.message}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur pour rejoindre le tournoi')),
        );
      }
    }
  }

  Future<void> _sendJoinRequest(BuildContext context, int tournamentId, int teamId) async {
    // Implémentez la logique pour envoyer une demande de rejoindre le tournoi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demande pour rejoindre envoyée')),
    );
  }
}

class UpvoteButton extends StatefulWidget {
  final Tournament tournament;

  const UpvoteButton({super.key, required this.tournament});

  @override
  _UpvoteButtonState createState() => _UpvoteButtonState();
}

class _UpvoteButtonState extends State<UpvoteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool _isUpvoted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.deepOrange,
    ).animate(_controller);

    _checkIfUpvoted();
  }

  Future<void> _checkIfUpvoted() async {
    final tournamentService = Provider.of<ITournamentService>(context, listen: false);

    try {
      bool hasUpvoted = await tournamentService.hasUpvoted(widget.tournament.id, 'username');
      setState(() {
        _isUpvoted = hasUpvoted;
      });
      if (_isUpvoted) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if upvoted: $e');
      }
    }
  }

  Future<void> _toggleUpvote() async {
    final tournamentService = Provider.of<ITournamentService>(context, listen: false);

    if (_isUpvoted) {
      final shouldRemove = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove Upvote'),
          content: const Text('Are you sure you want to remove your upvote?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      if (shouldRemove != true) {
        return;
      }
    }

    try {
      await tournamentService.upvoteTournament(widget.tournament.id, 'username');
      setState(() {
        _isUpvoted = !_isUpvoted;
      });
      if (_isUpvoted) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upvote status changed successfully')),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Upvote failed: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change upvote status: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleUpvote,
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Icon(
              Icons.local_fire_department,
              color: _colorAnimation.value,
            ),
          ),
          const SizedBox(width: 4),
          Text('${widget.tournament.upvotes + (_isUpvoted ? 1 : 0)}'), // Affiche le nombre de upvotes
        ],
      ),
    );
  }
}
