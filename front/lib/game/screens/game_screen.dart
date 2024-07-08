import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/game/bloc/game_bloc.dart';
import 'package:uresport/game/bloc/game_event.dart';
import 'package:uresport/game/bloc/game_state.dart';
import 'package:uresport/game/screens/game_detail.dart';
import 'package:uresport/shared/utils/filter_button.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  GamesScreenState createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen> {
  final List<String> _selectedTags = [];
  final List<String> _availableTags = [];
  String _sortOption = 'Alphabétique (A-Z)';
  final List<String> _sortOptions = [
    'Alphabétique (A-Z)',
    'Alphabétique (Z-A)'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(GameService(Dio()))..add(const LoadGames()),
      child: Scaffold(
        body: BlocListener<GameBloc, GameState>(
          listener: (context, state) {
            if (state is GameLoaded) {
              _updateAvailableTags(state.games);
            }
          },
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is GameLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GameLoaded) {
                List<Game> filteredGames = _filterAndSortGames(state.games);
                return RefreshIndicator(
                  onRefresh: () async {
                    _refreshGames(context);
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ListView.builder(
                      key: ValueKey<int>(filteredGames.length),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: filteredGames.length,
                      itemBuilder: (context, index) {
                        final game = filteredGames[index];
                        return GameCard(
                          key: ValueKey<int>(game.id),
                          game: game,
                          onTagSelected: (tag) {
                            setState(() {
                              if (_selectedTags.contains(tag)) {
                                _selectedTags.remove(tag);
                              } else {
                                _selectedTags.add(tag);
                              }
                            });
                            _filterGames(context);
                          },
                        );
                      },
                    ),
                  ),
                );
              } else if (state is GameError) {
                return const Center(child: Text('An error occurred!'));
              } else {
                return const Center(child: Text('No games available.'));
              }
            },
          ),
        ),
        floatingActionButton: FilterButton(
          availableTags: _availableTags,
          selectedTags: _selectedTags,
          sortOptions: _sortOptions,
          currentSortOption: _sortOption,
          onFilterChanged: (selectedTags, sortOption) {
            setState(() {
              _selectedTags.clear();
              _selectedTags.addAll(selectedTags);
              _sortOption = sortOption;
            });
            _filterGames(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _updateAvailableTags(List<Game> games) {
    setState(() {
      _availableTags.clear();
      Set<String> uniqueTags = {};
      for (var game in games) {
        uniqueTags.addAll(game.tags);
      }
      _availableTags.addAll(uniqueTags);
    });
  }

  List<Game> _filterAndSortGames(List<Game> games) {
    List<Game> filteredGames = _selectedTags.isEmpty
        ? games
        : games
            .where(
                (game) => game.tags.any((tag) => _selectedTags.contains(tag)))
            .toList();

    filteredGames.sort((a, b) {
      if (_sortOption == 'Alphabétique (A-Z)') {
        return a.name.compareTo(b.name);
      } else {
        return b.name.compareTo(a.name);
      }
    });

    return filteredGames;
  }

  void _refreshGames(BuildContext context) {
    context.read<GameBloc>().add(const LoadGames());
  }

  void _filterGames(BuildContext context) {
    context.read<GameBloc>().add(FilterGames(_selectedTags));
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
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return _buildLimitedTags(constraints.maxWidth);
                      },
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

  Widget _buildLimitedTags(double maxWidth) {
    const double tagSpacing = 8.0;
    const double moreTagWidth = 80.0;

    List<Widget> visibleTags = [];
    int hiddenTagsCount = 0;
    double currentLineWidth = 0.0;

    for (var tag in game.tags) {
      final tagWidth = _getTextWidth(tag) + 16.0;

      if (currentLineWidth + tagWidth + tagSpacing > maxWidth) {
        hiddenTagsCount++;
      } else {
        visibleTags.add(
          Padding(
            padding: const EdgeInsets.only(right: tagSpacing, bottom: 4.0),
            child: InkWell(
              onTap: () => onTagSelected(tag),
              child: Chip(
                label: Text(tag),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        );
        currentLineWidth += tagWidth + tagSpacing;

        if (currentLineWidth + moreTagWidth + tagSpacing > maxWidth) {
          break;
        }
      }
    }

    if (hiddenTagsCount > 0) {
      visibleTags.add(
        Chip(
          label: Text('+$hiddenTagsCount more'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return Wrap(
      children: visibleTags,
    );
  }

  double _getTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }
}
