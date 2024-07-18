import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uresport/bracket/screens/custom_bracket.dart';
import 'package:uresport/bracket/screens/custom_poules_page.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/shared/map/map.dart';
import 'package:uresport/tournament/bloc/tournament_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';
import 'package:uresport/l10n/app_localizations.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<TournamentBloc>().add(const LoadTournaments());
        },
        child: BlocBuilder<TournamentBloc, TournamentState>(
          builder: (context, state) {
            if (state is TournamentInitial) {
              BlocProvider.of<TournamentBloc>(context)
                  .add(const LoadTournaments());
              return const Center(child: CircularProgressIndicator());
            } else if (state is TournamentLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TournamentLoadSuccess) {
              return Stack(
                children: [
                  ListView.builder(
                    itemCount: state.tournaments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const TournamentBracketPage(
                                          tournamentId: 1),
                                    ),
                                  );
                                },
                                child: Text(l.customBracket),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const CustomPoulesPage(),
                                    ),
                                  );
                                },
                                child: Text(l.customPoules),
                              ),
                            ],
                          ),
                        );
                      } else {
                        final tournament = state.tournaments[index - 1];
                        return _buildTournamentCard(context, tournament);
                      }
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
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
              return Center(child: Text(l.failedToLoadTournaments));
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }

  Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
    AppLocalizations l = AppLocalizations.of(context);
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
              '${l.location}: ${tournament.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              '${l.startDate}: ${dateFormat.format(tournament.startDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              '${l.endDate}: ${dateFormat.format(tournament.endDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              l.participants,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Handle view details action
              },
              child: Text(l.viewDetails),
            ),
          ],
        ),
      ),
    );
  }
}
