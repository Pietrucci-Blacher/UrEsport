import 'package:flutter/material.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/l10n/app_localizations.dart';

class TournamentParticipantsScreen extends StatelessWidget {
  final Tournament tournament;

  const TournamentParticipantsScreen({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    debugPrint('Number of teams: ${tournament.teams.length}'); // Vérifiez le nombre d'équipes
    return Scaffold(
      appBar: AppBar(
        title: Text(l.tournamentParticipants),
      ),
      body: tournament.teams.isNotEmpty
          ? ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tournament.teams.length,
        itemBuilder: (context, index) {
          final team = tournament.teams[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  team.name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                team.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        },
      )
          : Center(child: Text(l.noParticipantsFound)),
    );
  }
}
