import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:intl/intl.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TournamentBloc, TournamentState>(
        builder: (context, state) {
          if (state is TournamentInitial) {
            BlocProvider.of<TournamentBloc>(context)
                .add(const LoadTournaments(limit: 10, page: 1));
            return const Center(child: CircularProgressIndicator());
          } else if (state is TournamentLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TournamentLoadSuccess) {
            return ListView.builder(
              itemCount: state.tournaments.length,
              itemBuilder: (context, index) {
                final tournament = state.tournaments[index];
                return _buildTournamentCard(context, tournament);
              },
            );
          } else if (state is TournamentLoadFailure) {
            return const Center(child: Text('Failed to load tournaments'));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
    final DateFormat dateFormat =
        DateFormat.yMMMd(Localizations.localeOf(context).toString());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tournament.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              tournament.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Location: ${tournament.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Start Date: ${dateFormat.format(tournament.startDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'End Date: ${dateFormat.format(tournament.endDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Participants: ${tournament.participants.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Handle view details action
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}
