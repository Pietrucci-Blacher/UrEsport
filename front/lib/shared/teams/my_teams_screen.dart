import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/team.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/team_services.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/tournament/screens/tournament_details_screen.dart';
import 'package:uresport/widgets/custom_toast.dart';

class MyTeamsScreen extends StatefulWidget {
  const MyTeamsScreen({super.key});

  @override
  MyTeamsScreenState createState() => MyTeamsScreenState();
}

class MyTeamsScreenState extends State<MyTeamsScreen> {
  User? _currentUser;
  List<Team>? _teams;

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

  Future<void> _loadUserTeams() async {
    if (_currentUser == null) return;
    final teamService = Provider.of<ITeamService>(context, listen: false);
    try {
      final teams = await teamService.getUserTeams(_currentUser!.id);
      if (!mounted) return;
      setState(() {
        _teams = teams;
      });
    } catch (e) {
      debugPrint('Error loading user teams: $e');
      setState(() {
        _teams = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser().then((_) => _loadUserTeams());
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.myTeams),
        ),
        body: Center(child: Text(l.mustBeLoggedIn)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.myTeams),
      ),
      body: _teams == null
          ? const Center(child: CircularProgressIndicator())
          : _teams!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.group, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(l.noTeamsFoundForUser,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUserTeams,
                  child: ListView.builder(
                    itemCount: _teams!.length,
                    itemBuilder: (context, index) {
                      final team = _teams![index];
                      return ExpansionTile(
                        title: Text(team.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${l.membersInTeam}: ${team.members.length} | ${l.tournamentsInTeam}: ${team.tournaments.length}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.exit_to_app, color: Colors.red),
                          onPressed: () =>
                              _confirmLeaveTeam(team.id, team.name),
                        ),
                        children: team.tournaments.map((tournamentJson) {
                          Tournament tournament =
                              Tournament.fromJson(tournamentJson);
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10.0),
                              leading: Image.network(tournament.image,
                                  width: 50, height: 50, fit: BoxFit.cover),
                              title: Text(tournament.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${l.start}: ${DateFormat.yMMMd().format(tournament.startDate)}',
                                      style: const TextStyle(fontSize: 14)),
                                  Text(
                                      '${l.end}: ${DateFormat.yMMMd().format(tournament.endDate)}',
                                      style: const TextStyle(fontSize: 14)),
                                  Text(tournament.description,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TournamentDetailsScreen(
                                      tournament: tournament,
                                      game: tournament.game,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
    );
  }

  Future<void> _confirmLeaveTeam(int teamId, String teamName) async {
    AppLocalizations l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.confirmLeave),
          content: Text('${l.leaveTeamConfirmation} $teamName?'),
          actions: <Widget>[
            TextButton(
              child: Text(l.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(l.leave),
              onPressed: () {
                Navigator.of(context).pop();
                _leaveTeam(teamId, teamName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _leaveTeam(int teamId, String teamName) async {
    AppLocalizations l = AppLocalizations.of(context);
    if (_currentUser == null) return;

    final userId = _currentUser!.id;
    final teamService = Provider.of<ITeamService>(context, listen: false);
    try {
      await teamService.leaveTeam(userId, teamId);
      _loadUserTeams();
      _showToast('${l.confirmLeaveTeam} $teamName', Colors.green);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        final errorResponse = e.response?.data;
        final errorMessage = errorResponse['error'] ?? l.failedToLeaveTeam;
        _showToast(errorMessage, Colors.red);
      } else {
        _showToast('${l.failedToLeaveTeam}: $e', Colors.red);
      }
    }
  }

  void _showToast(String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: CustomToast(
          message: message,
          backgroundColor: backgroundColor,
          onClose: () {
            overlayEntry.remove();
          },
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
