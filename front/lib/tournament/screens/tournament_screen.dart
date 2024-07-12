import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uresport/bracket/screens/custom_bracket.dart';
import 'package:uresport/bracket/screens/custom_poules_page.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/shared/map/map.dart';
import 'package:uresport/tournament/bloc/tournament_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';
import 'package:uresport/tournament/screens/tournament_details_screen.dart';
import 'package:uresport/widgets/gradient_icon.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TournamentBloc(context.read<ITournamentService>())
        ..add(const LoadTournaments()),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Liste Tournois'),
                Tab(text: 'Custom Bracket'),
                Tab(text: 'Custom Poules'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  context.read<TournamentBloc>().add(const LoadTournaments());
                },
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
              const TournamentBracketPage(),
              const CustomPoulesPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
    final DateFormat dateFormat = DateFormat.yMMMd(Localizations.localeOf(context).toString());

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TournamentDetailsScreen(tournament: tournament),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                tournament.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tournament.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      if (tournament.isPrivate)
                        const Icon(
                          Icons.lock,
                          color: Colors.red,
                        )
                      else
                        const Icon(
                          Icons.lock_open,
                          color: Colors.green,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tournament.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                tournament.location,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.videogame_asset,
                                  color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                'Game: ${tournament.game.name}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                'Start: ${dateFormat.format(tournament.startDate)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                'End: ${dateFormat.format(tournament.endDate)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              GradientIcon(
                                icon: Icons.local_fire_department,
                                size: 30.0,
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.red,
                                    Colors.red.withOpacity(0.7),
                                    Colors.orange,
                                    Colors.yellow,
                                    Colors.green, // Nouvelle couleur ajoutée à la fin
                                  ],
                                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${tournament.upvotes}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TournamentDetailsScreen(
                                      tournament: tournament),
                                ),
                              );
                            },
                            child: const Text('View Details'),
                          ),
                        ],
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
  }

}
