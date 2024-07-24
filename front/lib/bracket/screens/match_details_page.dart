import 'package:uresport/core/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uresport/core/models/match.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/match_service.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:uresport/l10n/app_localizations.dart';

class MatchNotifier extends ChangeNotifier {
  Match match;

  MatchNotifier(this.match);

  void updateMatch(Match updatedMatch) {
    match = updatedMatch;
    notifyListeners();
  }
}

class MatchDetailsPage extends StatefulWidget {
  final Match match;

  const MatchDetailsPage({required this.match, super.key});

  @override
  MatchDetailsPageState createState() => MatchDetailsPageState();
}

class MatchDetailsPageState extends State<MatchDetailsPage> {
  final TextEditingController _score = TextEditingController();
  final TextEditingController _score1 = TextEditingController();
  final TextEditingController _score2 = TextEditingController();
  final Websocket ws = Websocket.getInstance();
  late MatchNotifier matchNotifier;
  User? _currentUser;

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<IAuthService>(context, listen: false);
    try {
      final user = await authService.getUser();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  void websocket() {
    ws.on('match:update', (socket, data) async {
      if (data['id'] == matchNotifier.match.id) {
        matchNotifier.updateMatch(Match.fromJson(data));
      }
    });

    ws.emit('tournament:add-to-room', {
      'tournament_id': widget.match.tournamentId,
    });
  }

  @override
  void initState() {
    super.initState();
    matchNotifier = MatchNotifier(widget.match);
    _loadCurrentUser();
    websocket();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    var isTeam1Owner = _currentUser?.id == matchNotifier.match.team1?.ownerId;
    var isTeam2Owner = _currentUser?.id == matchNotifier.match.team2?.ownerId;
    var isTeamOwner = isTeam1Owner || isTeam2Owner;
    var isTournamentOwner =
        _currentUser?.id == matchNotifier.match.tournament?.ownerId;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.matchDetails),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListenableBuilder(
                    listenable: matchNotifier,
                    builder: (context, child) {
                      return Column(
                        children: [
                          _buildTeamHeader(
                              matchNotifier.match.team1?.name ?? '',
                              matchNotifier.match.team2?.name ?? ''),
                          const Divider(thickness: 2),
                          _buildCustomScoreRow(
                              l.score,
                              matchNotifier.match.score1.toString(),
                              matchNotifier.match.score2.toString()),
                          const Divider(thickness: 2),
                          _buildStatColumn(
                              l.status, matchNotifier.match.status),
                          _buildStatColumn(
                              l.winner,
                              matchNotifier.match.getWinner()?.name ??
                                  l.noWinnerYet),
                          if (matchNotifier.match.team1Close)
                            _buildStatColumn(
                                matchNotifier.match.team1?.name ?? '',
                                matchNotifier.match.team1Close
                                    ? l.proposeToClose
                                    : ''),
                          if (matchNotifier.match.team2Close)
                            _buildStatColumn(
                                matchNotifier.match.team2?.name ?? '',
                                matchNotifier.match.team2Close
                                    ? l.proposeToClose
                                    : ''),
                          if ((isTeamOwner || isTournamentOwner) &&
                              matchNotifier.match.winnerId == null)
                            const Divider(thickness: 2),
                          if (isTeamOwner &&
                              matchNotifier.match.winnerId == null)
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _openScoreModal(isTeam1Owner
                                      ? matchNotifier.match.team1Id ?? 0
                                      : matchNotifier.match.team2Id ?? 0);
                                },
                                child: Text(
                                    '${l.updateScore} ${isTeam1Owner ? matchNotifier.match.team1?.name : matchNotifier.match.team2?.name}'),
                              ),
                            ),
                          if (isTeamOwner &&
                              matchNotifier.match.winnerId == null)
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _closeMatch(isTeam1Owner
                                      ? matchNotifier.match.team1Id ?? 0
                                      : matchNotifier.match.team2Id ?? 0);
                                },
                                child: Text(isTeam1Owner &&
                                            matchNotifier.match.team1Close ||
                                        isTeam2Owner &&
                                            matchNotifier.match.team2Close
                                    ? l.cancelCloseMatch
                                    : l.closeMatch),
                              ),
                            ),
                          if (isTournamentOwner)
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _openUpdateModal();
                                },
                                child: Text(l.updateMatch),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _closeMatch(int teamId) async {
    final teamService = Provider.of<IMatchService>(context, listen: false);
    try {
      final updatedMatch =
          await teamService.closeMatch(matchNotifier.match.id, teamId);
      matchNotifier.updateMatch(updatedMatch);
    } catch (e) {
      if (e is DioException) {
        if (!mounted) return;
        showNotificationToast(context, e.error.toString(),
            backgroundColor: Colors.red);
      }
    }
  }

  void _openUpdateModal() {
    final teamService = Provider.of<IMatchService>(context, listen: false);
    AppLocalizations l = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.updateMatch),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _score1,
                decoration: InputDecoration(labelText: l.team1Score),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _score2,
                decoration: InputDecoration(labelText: l.team2Score),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final inputScore1 = int.tryParse(_score1.text);
                final inputScore2 = int.tryParse(_score2.text);
                try {
                  final updatedMatch =
                      await teamService.updateMatch(matchNotifier.match.id, {
                    'score1': inputScore1,
                    'score2': inputScore2,
                  });
                  matchNotifier.updateMatch(updatedMatch);
                } catch (e) {
                  if (e is DioException && context.mounted) {
                    showNotificationToast(context, e.error.toString(),
                        backgroundColor: Colors.red);
                  }
                }
                _score1.clear();
                _score2.clear();
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: Text(l.updateScore),
            ),
          ],
        );
      },
    );
  }

  void _openScoreModal(int teamId) {
    final teamService = Provider.of<IMatchService>(context, listen: false);
    AppLocalizations l = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.updateScore),
          content: TextFormField(
            controller: _score,
            decoration: InputDecoration(labelText: l.score),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final inputScore = int.tryParse(_score.text) ?? 0;
                try {
                  final updatedMatch = await teamService.setScore(
                      matchNotifier.match.id, teamId, inputScore);
                  matchNotifier.updateMatch(updatedMatch);
                } catch (e) {
                  if (e is DioException && context.mounted) {
                    showNotificationToast(context, e.error.toString(),
                        backgroundColor: Colors.red);
                  }
                }
                _score.clear();
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: Text(l.updateScore),
            ),
          ],
        );
      },
    );
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

  Widget _buildTeamHeader(String team1, String team2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                team1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  'A',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Text(
            'VS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                team2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  'B',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String statName, String statValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            statName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            statValue,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour créer la ligne personnalisée du score
  Widget _buildCustomScoreRow(
      String statName, String statValue1, String statValue2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.sports_soccer, color: Colors.blue),
                const SizedBox(height: 5),
                Text(
                  statValue1,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  statName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.sports_soccer, color: Colors.red),
                const SizedBox(height: 5),
                Text(
                  statValue2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
