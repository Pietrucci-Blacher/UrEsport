import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/like_service.dart';
import 'package:uresport/tournament/screens/tournament_details_screen.dart';
import 'package:uresport/core/models/like.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:uresport/l10n/app_localizations.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;

  const GameDetailPage({super.key, required this.game});

  @override
  GameDetailPageState createState() => GameDetailPageState();
}

class GameDetailPageState extends State<GameDetailPage> {
  late Future<List<Tournament>> _futureTournaments;
  final GameService _gameService = GameService(Dio());
  final LikeService _likeService = LikeService(Dio(BaseOptions(
    followRedirects: true,
    validateStatus: (status) {
      return status != null && status < 400;
    },
  )));
  User? _currentUser;
  Like? _currentLike; // Keep a reference to the current like
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _futureTournaments = _gameService.fetchTournamentsByGameId(widget.game.id);
  }

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<IAuthService>(context, listen: false);
    try {
      final user = await authService.getUser();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
      debugPrint('Current user loaded: ${_currentUser!.id}');
      _checkIfLiked(); // Appeler _checkIfLiked après avoir chargé l'utilisateur
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  void _navigateToTournamentDetails(Tournament tournament) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TournamentDetailsScreen(
          tournament: tournament,
          game: widget.game,
        ),
      ),
    );
  }

  Future<void> _checkIfLiked() async {
    if (_currentUser == null) {
      debugPrint('Current user is null, cannot check like status');
      return;
    }

    try {
      debugPrint(
          'Checking if liked for user: ${_currentUser!.id} and game: ${widget.game.id}');
      final likes = await _likeService.getLikesByUserIdAndGameId(
          _currentUser!.id, widget.game.id);
      debugPrint('Response from GetLikesByUserIDAndGameID: $likes');
      setState(() {
        if (likes.isNotEmpty) {
          _currentLike = likes.first;
          _isLiked = true;
        } else {
          _currentLike = null;
          _isLiked = false;
        }
        debugPrint('Like status updated: $_isLiked');
      });
    } catch (e) {
      debugPrint('Error checking if liked: $e');
    }
  }

  Future<void> _createLike() async {
    AppLocalizations l = AppLocalizations.of(context);
    if (_currentUser == null) {
      _showToast(context, l.needConnected, Colors.red);
      return;
    }

    try {
      Like newLike = Like(
          userId: _currentUser!.id, gameId: widget.game.id, game: widget.game);
      debugPrint('Creating like with data: ${newLike.toJson()}');
      final createdLike = await _likeService.createLike(newLike);
      setState(() {
        _isLiked = true;
        _currentLike = createdLike; // Update the current like
      });
      if (!mounted) return;
      _showToast(context, l.addedToGameList, Colors.green);
    } catch (e) {
      debugPrint('Error: $e');
      _showToast(context, '${l.errorFollowingGame} : $e', Colors.red);
    }
  }

  Future<void> _deleteLike() async {
    AppLocalizations l = AppLocalizations.of(context);
    if (_currentLike == null) {
      _showToast(context, l.noLikeToDelete, Colors.red);
      return;
    }

    try {
      await _likeService.deleteLike(_currentLike!.id!);
      setState(() {
        _isLiked = false;
        _currentLike = null; // Clear the current like
      });
      if (!mounted) return;
      _showToast(context, l.removedFromGameList, Colors.red);
    } catch (e) {
      debugPrint('Error: $e');
      _showToast(context, '${l.errorUnfollowingGame} : $e', Colors.red);
    }
  }

  void _showToast(BuildContext context, String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomToast(
        message: message,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
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
    AppLocalizations l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        actions: [
          IconButton(
            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : null),
            onPressed: () {
              if (_isLiked) {
                _deleteLike();
              } else {
                _createLike();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.game.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l.gameDescription,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.game.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                l.tags,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: widget.game.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Divider(
                color: Colors.grey[600],
                thickness: 3,
              ),
              Text(
                l.tournamentText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Tournament>>(
                future: _futureTournaments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${l.error}: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final tournaments = snapshot.data!;
                    debugPrint('Tournaments loaded: ${tournaments.length}');
                    for (var tournament in tournaments) {
                      debugPrint('Tournament: ${tournament.name}, Participants: ${tournament.teams.length}');
                    }
                    if (tournaments.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                              size: 100,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l.nothingTournamentforGame,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tournaments.length,
                      itemBuilder: (context, index) {
                        final tournament = tournaments[index];
                        return GestureDetector(
                          onTap: () {
                            _navigateToTournamentDetails(tournament);
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15.0)),
                                  child: Image.network(
                                    tournament.image,
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              tournament.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            tournament.isPrivate
                                                ? Icons.lock
                                                : Icons.lock_open,
                                            color: tournament.isPrivate
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        tournament.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              tournament.location,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.date_range,
                                              color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${l.startDate}'
                                            '${dateFormat.format(tournament.startDate)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.date_range,
                                              color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${l.endDate}'
                                            '${dateFormat.format(tournament.endDate)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text(l.noTournamentsFound));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
