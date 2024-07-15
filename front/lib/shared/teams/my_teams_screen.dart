import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:uresport/tournament/screens/tournament_details_screen.dart';

import 'package:uresport/core/models/tournament.dart';

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
          } else if (!snapshot.hasData || (snapshot.data as List<Team>).isEmpty) {
            return const Center(child: Text('No teams found for the user'));
          } else {
            final teams = snapshot.data as List<Team>;
            debugPrint('Teams data: $teams');
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return ExpansionTile(
                  title: Text(team.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Members: ${team.members.length} | Tournaments: ${team.tournaments.length}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  children: team.tournaments.map((tournamentJson) {
                    Tournament tournament = Tournament.fromJson(tournamentJson);
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        leading: Image.network(tournament.image, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(tournament.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start: ${DateFormat.yMMMd().format(tournament.startDate)}', style: TextStyle(fontSize: 14)),
                            Text('End: ${DateFormat.yMMMd().format(tournament.endDate)}', style: TextStyle(fontSize: 14)),
                            Text(tournament.description, style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TournamentDetailsScreen(tournament: tournament),
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

  Future<List<Team>> _loadUserTeams() async {
    if (_currentUser == null) {
      throw Exception('User is not logged in');
    }

    final userId = _currentUser!.id;
    final tournamentService = Provider.of<ITournamentService>(context, listen: false);
    return await tournamentService.getUserTeams(userId);
  }
}
