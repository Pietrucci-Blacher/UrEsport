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

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
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
      body: FutureBuilder(
        future: _loadUserTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            debugPrint('Error in FutureBuilder: ${snapshot.error}');
            return const Center(child: Text('Failed to load user teams'));
          } else if (!snapshot.hasData ||
              (snapshot.data as List<Team>).isEmpty) {
            return const Center(child: Text('No teams found for the user'));
          } else {
            final teams = snapshot.data as List<Team>;
            debugPrint('Teams data: $teams');
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return ExpansionTile(
                  title: Text(team.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Members: ${team.members.length} | Tournaments: ${team.tournaments.length}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.exit_to_app, color: Colors.red),
                    onPressed: () => _confirmLeaveTeam(team.id, team.name),
                  ),
                  children: team.tournaments.map((tournamentJson) {
                    Tournament tournament = Tournament.fromJson(tournamentJson);
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10.0),
                        leading: Image.network(tournament.image,
                            width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(tournament.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Start: ${DateFormat.yMMMd().format(tournament.startDate)}',
                                style: const TextStyle(fontSize: 14)),
                            Text(
                                'End: ${DateFormat.yMMMd().format(tournament.endDate)}',
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
                              builder: (context) => TournamentDetailsScreen(
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
            );
          }
        },
      ),
    );
  }

  Future<void> _confirmLeaveTeam(int teamId, String teamName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Leave'),
          content: Text('Are you sure you want to leave the team $teamName?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Leave'),
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
    if (_currentUser == null) return;

    final userId = _currentUser!.id;
    final teamService = Provider.of<ITeamService>(context, listen: false);
    try {
      await teamService.leaveTeam(userId, teamId);
      setState(() {
        _loadUserTeams();
      });
      _showToast('Vous avez bien quitté la team $teamName', Colors.green);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        final errorResponse = e.response?.data;
        final errorMessage =
            errorResponse['error'] ?? 'Failed to leave the team';
        _showToast(errorMessage, Colors.red);
      } else {
        _showToast('Failed to leave the team: $e', Colors.red);
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

  Future<List<Team>> _loadUserTeams() async {
    if (_currentUser == null) {
      throw Exception('User is not logged in');
    }

    final userId = _currentUser!.id;
    final teamService = Provider.of<ITeamService>(context, listen: false);
    return await teamService.getUserTeams(userId);
  }
}
