import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TournamentBloc(TournamentService(Dio()))
            ..add(const LoadTournaments(limit: 5, page: 1)),
        ),
        BlocProvider(
          create: (context) => GameBloc(GameService(Dio()))..add(LoadGames()),
        ),
      ],
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<TournamentBloc>().add(const LoadTournaments(limit: 5, page: 1));
            context.read<GameBloc>().add(LoadGames());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tournois en tendance',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  _buildTrendingTournaments(context),
                  const SizedBox(height: 20),
                  Text(
                    'Jeux populaires',
                    style: Theme.of(context).textTheme.headlineSmall,
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

  Widget _buildTrendingTournament(BuildContext context, List<Tournament> tournaments) {
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

    final tournament = tournaments.first;
    return GestureDetector(
      onTap: () {
        // Naviguer vers la page de détails du tournoi
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
        height: 150,
        width: double.infinity,
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
