import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/game/bloc/game_bloc.dart';
import 'package:uresport/game/bloc/game_event.dart';
import 'package:uresport/game/bloc/game_state.dart';
import 'package:uresport/game/screens/game_detail.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/shared/utils/filter_button.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  GamesScreenState createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen> {
  final List<String> _selectedTags = [];
  final List<String> _allAvailableTags = [];
  List<String> _filteredAvailableTags = [];
  late String _sortOption;
  late List<String> _sortOptions;

  bool _isInitialized = false;
  int _currentSortIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSortOptions();
  }

  void _updateSortOptions() {
    final newSortOptions = [
      AppLocalizations.of(context).alphabeticalAZ,
      AppLocalizations.of(context).alphabeticalZA
    ];

    if (!_isInitialized) {
      _sortOptions = newSortOptions;
      _sortOption = _sortOptions[_currentSortIndex];
      _isInitialized = true;
    } else {
      _currentSortIndex = _sortOptions.indexOf(_sortOption);
      _sortOptions = newSortOptions;
      _sortOption = _sortOptions[_currentSortIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(GameService(Dio()))..add(const LoadGames()),
      child: Scaffold(
        body: BlocListener<GameBloc, GameState>(
          listener: (context, state) {
            if (state is GameLoaded) {
              _updateAllAvailableTags(state.games);
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
                              _updateFilteredAvailableTags();
                            });
                            _filterGames(context);
                          },
                        );
                      },
                    ),
                  ),
                );
              } else if (state is GameError) {
                return Center(
                    child: Text(AppLocalizations.of(context).anErrorOccurred));
              } else {
                return Center(
                    child: Text(AppLocalizations.of(context).noGamesAvailable));
              }
            },
          ),
        ),
        floatingActionButton: FilterButton(
          availableTags: _filteredAvailableTags,
          selectedTags: _selectedTags,
          sortOptions: _sortOptions,
          currentSortOption: _sortOption,
          onFilterChanged: (selectedTags, sortOption) {
            setState(() {
              _selectedTags.clear();
              _selectedTags.addAll(selectedTags);
              _sortOption = sortOption;
              _currentSortIndex = _sortOptions.indexOf(sortOption);
              _updateFilteredAvailableTags();
            });
            _filterGames(context);
          },
          isSingleSelection: false, // Activer la sélection multiple
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _updateAllAvailableTags(List<Game> games) {
    setState(() {
      _allAvailableTags.clear();
      Set<String> uniqueTags = {};
      for (var game in games) {
        uniqueTags.addAll(game.tags);
      }
      _allAvailableTags.addAll(uniqueTags);
      _updateFilteredAvailableTags();
    });
  }

  void _updateFilteredAvailableTags() {
    setState(() {
      _filteredAvailableTags = _allAvailableTags.toList();
    });
  }

  List<Game> _filterAndSortGames(List<Game> games) {
    List<Game> filteredGames = games;

    if (_selectedTags.isNotEmpty) {
      filteredGames = games
          .where(
              (game) => _selectedTags.every((tag) => game.tags.contains(tag)))
          .toList();
    }

    filteredGames.sort((a, b) {
      if (_sortOption == AppLocalizations.of(context).alphabeticalAZ) {
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
                        return _buildLimitedTags(context, constraints.maxWidth);
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

  Widget _buildLimitedTags(BuildContext context, double maxWidth) {
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
          label:
              Text('${AppLocalizations.of(context).moreTagsCount} $hiddenTagsCount ${AppLocalizations.of(context).more}'),
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
