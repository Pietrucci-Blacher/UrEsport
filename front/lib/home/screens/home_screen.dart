import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uresport/game/bloc/game_bloc.dart';
import 'package:uresport/game/bloc/game_event.dart';
import 'package:uresport/game/bloc/game_state.dart';
import 'package:uresport/tournament/bloc/tournament_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/game/screens/game_detail.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TournamentBloc(TournamentService(Dio()))
            ..add(const LoadTournaments(limit: 10, page: 1)),
        ),
        BlocProvider(
          create: (context) =>
              GameBloc(GameService(Dio()))..add(const LoadGames(limit: 10)),
        ),
      ],
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<TournamentBloc>()
                .add(const LoadTournaments(limit: 10, page: 1));
            context.read<GameBloc>().add(const LoadGames(limit: 10));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tournois en tendance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TournamentScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Text('Afficher tout'),
                            SizedBox(width: 5),
                            FaIcon(FontAwesomeIcons.arrowRight, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTrendingTournaments(context),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jeux populaires',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to the full game list screen if needed
                        },
                        child: const Row(
                          children: [
                            Text('Afficher tout'),
                            SizedBox(width: 5),
                            FaIcon(FontAwesomeIcons.arrowRight, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildGamesList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingTournaments(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        if (state is TournamentLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TournamentLoadSuccess) {
          return _buildTrendingTournament(context, state.tournaments);
        } else if (state is TournamentLoadFailure) {
          return const Center(child: Text('Failed to load data'));
        } else {
          return const Center(child: Text('No tournaments available.'));
        }
      },
    );
  }

  Widget _buildTrendingTournament(
      BuildContext context, List<Tournament> tournaments) {
    if (tournaments.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    final mainTournament = tournaments.first;
    final otherTournaments =
        tournaments.length > 1 ? tournaments.sublist(1) : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(mainTournament.name),
                  ),
                  body: Center(
                    child: Text('Détails du tournoi ${mainTournament.name}'),
                  ),
                ),
              ),
            );
          },
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(mainTournament.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Divider(
          color: Colors.grey.shade300, // Couleur discrète
          thickness: 1, // Épaisseur fine
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: otherTournaments.length,
            itemBuilder: (context, index) {
              final tournament = otherTournaments[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(tournament.name),
                        ),
                        body: Center(
                          child: Text('Détails du tournoi ${tournament.name}'),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(tournament.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGamesList(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GameLoaded) {
          return _buildGames(context, state.games);
        } else if (state is GameError) {
          return const Center(child: Text('Failed to load data'));
        } else {
          return const Center(child: Text('No games available.'));
        }
      },
    );
  }

  Widget _buildGames(BuildContext context, List<Game> games) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailPage(game: game),
                ),
              );
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(game.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
