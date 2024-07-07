import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/game/bloc/game_bloc.dart';
import 'package:uresport/game/bloc/game_event.dart';
import 'package:uresport/game/bloc/game_state.dart';
import 'package:uresport/game/screens/game_detail.dart';
import 'package:uresport/shared/utils/filter_button.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override GamesScreenState createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen> {
  final Set<String> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(GameService(Dio()))..add(const LoadGames()),
      child: Scaffold(
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GameLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GameBloc>().add(const LoadGames());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: state.games.length,
                  itemBuilder: (context, index) {
                    final game = state.games[index];
                    return GameCard(
                      game: game,
                      onTagSelected: (tag) {
                        setState(() {
                          if (_selectedTags.contains(tag)) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        });
                        if (_selectedTags.isEmpty) {
                          context.read<GameBloc>().add(const LoadGames());
                        } else {
                          context.read<GameBloc>().add(FilterGames(_selectedTags.toList()));
                        }
                      },
                    );
                  },
                ),
              );
            } else if (state is GameError) {
              return const Center(child: Text('An error occurred!'));
            } else {
              return const Center(child: Text('No games available.'));
            }
          },
        ),
        floatingActionButton: FilterButton(
          onFilterChanged: (selectedTags) {
            setState(() {
              _selectedTags.clear();
              _selectedTags.addAll(selectedTags);
            });
            if (_selectedTags.isEmpty) {
              context.read<GameBloc>().add(const LoadGames());
            } else {
              context.read<GameBloc>().add(FilterGames(_selectedTags.toList()));
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Game game;
  final void Function(String tag) onTagSelected;

  const GameCard({super.key, required this.game, required this.onTagSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameDetailPage(game: game)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  game.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: game.tags.map((tag) {
                        return InkWell(
                          onTap: () => onTagSelected(tag),
                          child: Chip(
                            label: Text(tag),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
