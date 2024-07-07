import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uresport/bracket/screens/custom_bracket.dart';
import 'package:uresport/bracket/screens/custom_poules_page.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/shared/map/map.dart'; // Ensure this import points to the correct file where TournamentMapWidget is defined
import 'package:uresport/tournament/bloc/tournament_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TournamentBloc(context.read<ITournamentService>())
        ..add(const LoadTournaments()),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<TournamentBloc>().add(const LoadTournaments());
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TournamentBracketPage(),
                          ),
                        );
                      },
                      child: const Text('Custom Bracket'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomPoulesPage(),
                          ),
                        );
                      },
                      child: const Text('Custom Poules'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<TournamentBloc, TournamentState>(
                  builder: (context, state) {
                    if (state is TournamentInitial) {
                      context
                          .read<TournamentBloc>()
                          .add(const LoadTournaments());
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TournamentLoadInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TournamentLoadSuccess) {
                      return Stack(
                        children: [
                          ListView.builder(
                            itemCount: state.tournaments.length,
                            itemBuilder: (context, index) {
                              final tournament = state.tournaments[index];
                              return _buildTournamentCard(context, tournament);
                            },
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: FloatingActionButton(
                              heroTag: 'map-fab',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TournamentMapWidget(
                                        tournaments: state.tournaments),
                                  ),
                                );
                              },
                              child: const Icon(Icons.map),
                            ),
                          ),
                        ],
                      );
                    } else if (state is TournamentLoadFailure) {
                      return const Center(
                          child: Text('Failed to load tournaments'));
                    }
                    return const Center(child: Text('Unknown state'));
                  },
                ),
              ),
            ],
          ),
        ),
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
            const Text(
              'Participants:',
              style: TextStyle(fontSize: 16),
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
