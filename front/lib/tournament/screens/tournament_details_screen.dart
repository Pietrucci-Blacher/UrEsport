import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/bracket/screens/custom_bracket.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/models/tournament.dart' as tournament_model;
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/game/screens/game_detail.dart';
import 'package:uresport/tournament/screens/tournament_particip.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:uresport/widgets/gradient_icon.dart';
import 'package:uresport/widgets/rating.dart';

class TournamentDetailsScreen extends StatefulWidget {
  final tournament_model.Tournament tournament;
  final Game? game;

  const TournamentDetailsScreen(
      {super.key, required this.tournament, this.game});

  @override
  TournamentDetailsScreenState createState() => TournamentDetailsScreenState();
}

class TournamentDetailsScreenState extends State<TournamentDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _hasJoined = false;
  User? _currentUser;
  List<tournament_model.Team> _teams = [];
  bool _hasUpvoted = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<IAuthService>(context, listen: false);
    try {
      final user = await authService.getUser();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
      await _checkIfJoined();
      await _checkIfUpvoted();
      await _loadTeams();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading current user: $e');
      }
    }
  }

  Future<void> _checkIfUpvoted() async {
    if (_currentUser == null) return;
    final tournamentService =
        Provider.of<ITournamentService>(context, listen: false);
    try {
      final hasUpvoted = await tournamentService.hasUpvoted(
          widget.tournament.id, _currentUser!.id);
      if (!mounted) return;
      setState(() {
        _hasUpvoted = hasUpvoted;
      });
      if (_hasUpvoted) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        setState(() {
          _hasUpvoted = false;
        });
      } else {
        if (kDebugMode) {
          debugPrint('Error checking if upvoted: $e');
        }
      }
    }
  }

  Future<void> _checkIfJoined() async {
    if (_currentUser == null) return;
    final tournamentService =
        Provider.of<ITournamentService>(context, listen: false);
    try {
      final hasJoined = await tournamentService.hasJoinedTournament(
          widget.tournament.id, _currentUser!.id.toString());
      if (!mounted) return;
      setState(() {
        _hasJoined = hasJoined;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking if joined: $e');
      }
      if (!mounted) return;
      setState(() {});
    }
  }

  Future<void> _loadTeams() async {
    final tournamentService =
        Provider.of<ITournamentService>(context, listen: false);
    try {
      final teams = await tournamentService.fetchTeams();
      if (!mounted) return;
      setState(() {
        _teams = teams;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading teams: $e');
      }
      setState(() {});
      showNotificationToast(context, 'Error loading teams: $e',
          backgroundColor: Colors.red);
    }
  }

  void showNotificationToast(BuildContext context, String message,
      {Color? backgroundColor, Color? textColor}) {
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

  void _showJoinTeamsModal() {
    if (_currentUser == null || _currentUser!.teams.isEmpty) {
      showNotificationToast(context, 'No teams available for the current user.',
          backgroundColor: Colors.red);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Team to Join'),
          content: _currentUser!.teams.isEmpty
              ? const Text('No teams available.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _currentUser!.teams.map((team) {
                    return ListTile(
                      title: Text(team.name),
                      onTap: () {
                        Navigator.pop(context);
                        _joinTournament(context, widget.tournament.id, team.id);
                      },
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showTeamsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Teams',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                _teams.isEmpty
                    ? const Text('No teams available.')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _teams.length,
                        itemBuilder: (context, index) {
                          final team = _teams[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                team.name[0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(team.name),
                            onTap: () async {
                              Navigator.pop(context); // Close the modal
                              await _sendInvite(team.id, team.name);
                            },
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendInvite(int teamId, String teamName) async {
    final tournamentService =
        Provider.of<ITournamentService>(context, listen: false);

    try {
      await tournamentService.inviteTeamToTournament(
          widget.tournament.id, teamId, teamName);
      if (!mounted) return;
      showNotificationToast(context, 'Invitation sent',
          backgroundColor: Colors.green);
    } catch (e) {
      debugPrint('Error sending invitation: $e');
      if (!mounted) return;
      showNotificationToast(context, 'Failed to send invitation: $e',
          backgroundColor: Colors.red);
    }
  }

  Future<void> generateBracket() async {
    final tournamentService =
        Provider.of<ITournamentService>(context, listen: false);

    try {
      await tournamentService.generateBracket(widget.tournament.id);
      if (!mounted) return;
      showNotificationToast(context, 'Bracket generated',
          backgroundColor: Colors.green);
    } catch (e) {
      debugPrint('Error generating bracket: $e');
      if (!mounted) return;
      showNotificationToast(context, 'Failed to generate bracket: $e',
          backgroundColor: Colors.red);
    }
  }

  Future<void> _toggleUpvote() async {
    if (_currentUser == null) {
      showNotificationToast(context, 'You must be logged in to upvote',
          backgroundColor: Colors.red);
      return;
    }

    final tournamentService =
        Provider.of<ITournamentService>(context, listen: false);

    try {
      await tournamentService.upvoteTournament(
          widget.tournament.id, _currentUser!.id.toString());
      if (!mounted) return;
      setState(() {
        _hasUpvoted = !_hasUpvoted;
      });
      if (_hasUpvoted) {
        _controller.forward();
        showNotificationToast(context, 'Upvote ajouté',
            backgroundColor: Colors.green);
      } else {
        _controller.reverse();
        showNotificationToast(context, 'Upvote retiré',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      debugPrint('Upvote failed: $e');
      if (!mounted) return;
      showNotificationToast(context, 'Failed to change upvote status: $e',
          backgroundColor: Colors.red);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.tournament.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Bracket'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _pageDetail(),
            _currentUser != null
                ? TournamentBracketPage(tournamentId: widget.tournament.id)
                : const Center(
                    child: Text('You must be logged in to view your bracket'),
                  ),
          ],
        ),
        floatingActionButton: _currentUser != null &&
                widget.tournament.ownerId == _currentUser!.id
            ? FloatingActionButton(
                onPressed: _showTeamsModal,
                child: const Icon(Icons.list),
              )
            : null,
      ),
    );
  }

  Widget _pageDetail() {
    final DateFormat dateFormat = DateFormat.yMMMd();
    var isOwner = widget.tournament.ownerId == _currentUser?.id;

    return SingleChildScrollView(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.tournament.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  widget.tournament.isPrivate ? Icons.lock : Icons.lock_open,
                  color:
                      widget.tournament.isPrivate ? Colors.red : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              widget.tournament.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Location: ${widget.tournament.location}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.videogame_asset, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.game != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GameDetailPage(game: widget.game!),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Game: ${widget.game?.name ?? widget.tournament.game.name}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Start Date: ${dateFormat.format(widget.tournament.startDate)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'End Date: ${dateFormat.format(widget.tournament.endDate)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upvotes',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap:
                                  _currentUser != null ? _toggleUpvote : null,
                              child: Row(
                                children: [
                                  AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, child) {
                                      return GradientIcon(
                                        icon: Icons.local_fire_department,
                                        size: 24.0,
                                        gradient: LinearGradient(
                                          colors: _hasUpvoted
                                              ? [
                                                  Colors.red,
                                                  Colors.orange,
                                                  Colors.yellow
                                                ]
                                              : [
                                                  Colors.grey,
                                                  Colors.grey.shade600
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.tournament.upvotes + (_hasUpvoted ? 1 : 0)}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Participants',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...widget.tournament.teams
                                .take(3)
                                .map((team) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.blue,
                                            child: Text(
                                              team.name[0],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              team.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                            if (widget.tournament.teams.length > 3)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TournamentParticipantsScreen(
                                          tournament: widget.tournament,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.group,
                                          size: 16,
                                          color:
                                              Theme.of(context).primaryColor),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          'Voir tous (${widget.tournament.teams.length})',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right,
                                          size: 16,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (isOwner)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    generateBracket();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Générer le bracket'),
                ),
              ),
            if (!_hasJoined &&
                widget.tournament.ownerId != _currentUser?.id &&
                !widget.tournament.isPrivate)
              Center(
                child: ElevatedButton(
                  onPressed: _currentUser != null
                      ? _showJoinTeamsModal
                      : null, // Show the modal to select a team
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Rejoindre le tournoi'),
                ),
              ),
            const SizedBox(height: 16),
            if (_currentUser != null)
              RatingWidget(
                tournamentId: widget.tournament.id,
                showCustomToast: showNotificationToast,
                userId: _currentUser!.id,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinTournament(
      BuildContext context, int tournamentId, int teamId) async {
    final tournamentService =
        Provider.of<ITournamentService>(context, listen: false);

    try {
      await tournamentService.joinTournament(tournamentId, teamId);
      if (!mounted) return;
      _showNotificationToast('Vous avez bien rejoint le tournoi', Colors.green);
      setState(() {
        _hasJoined = true;
      });
    } catch (e) {
      if (!mounted) return;
      _handleJoinError(e);
    }
  }

  void _showNotificationToast(String message, Color backgroundColor) {
    if (!mounted) return;
    showNotificationToast(context, message, backgroundColor: backgroundColor);
  }

  void _handleJoinError(dynamic e) {
    if (e is DioException) {
      if (e.response != null && e.response?.data != null) {
        final errorMessage = e.response?.data['error'];
        if (errorMessage == 'Team already in this tournament') {
          _showNotificationToast(
              'Vous avez déjà rejoint le tournoi', Colors.red);
          setState(() {
            _hasJoined = true;
          });
        } else {
          _showNotificationToast(
              'Erreur lors du join: $errorMessage', Colors.red);
        }
      } else {
        _showNotificationToast('Erreur lors du join: ${e.message}', Colors.red);
      }
    } else {
      _showNotificationToast('Erreur pour rejoindre le tournoi', Colors.red);
    }
  }
}
