import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/models/game.dart';
import 'package:uresport/dashboard/models/tournament.dart';
import 'package:uresport/dashboard/models/data.dart';
import 'package:uresport/core/services/tournament_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    final Dio dio = Dio();
    final TournamentService tournamentService = TournamentService(dio);

    return BlocProvider(
      create: (context) =>
      DashboardBloc(Websocket.getInstance(), tournamentService)..add(FetchTournaments()),
      child: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  selectedIcon: Icon(Icons.list),
                  label: Text('Logs'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.emoji_events),
                  selectedIcon: Icon(Icons.emoji_events),
                  label: Text('Tournaments'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.games),
                  selectedIcon: Icon(Icons.games),
                  label: Text('Games'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people),
                  selectedIcon: Icon(Icons.people),
                  label: Text('Users'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardLoaded) {
                    print('DashboardLoaded state: ${state.tournaments}');
                    switch (_selectedIndex) {
                      case 0:
                        return _buildDashboardContent(state);
                      case 1:
                        return _buildLogsContent(state);
                      case 2:
                        return _buildTournamentsContent(state);
                      case 3:
                        return _buildGamesContent(state);
                      case 4:
                        return _buildUsersContent(state);
                      default:
                        return const Center(child: Text('Unknown page'));
                    }
                  } else if (state is DashboardError) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return const Center(child: Text('Unknown state'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _selectedIndex == 2
            ? FloatingActionButton(
          onPressed: () {
            _showTournamentDialog(context);
          },
          child: const Icon(Icons.add),
        )
            : null,
      ),
    );
  }

  Widget _buildDashboardContent(DashboardLoaded state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Active Users: ${state.activeUsers}'),
          Text('Active Tournaments: ${state.activeTournaments}'),
          Text('Total Games: ${state.totalGames}'),
          Text('Latest Message: ${state.message}'),
        ],
      ),
    );
  }

  Widget _buildLogsContent(DashboardLoaded state) {
    return ListView.builder(
      itemCount: state.recentLogs.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(state.recentLogs[index]),
        );
      },
    );
  }

  Widget _buildTournamentsContent(DashboardLoaded state) {
    final ScrollController scrollController = ScrollController();

    return Center(
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Start Date')),
              DataColumn(label: Text('End Date')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Latitude')),
              DataColumn(label: Text('Longitude')),
              DataColumn(label: Text('Owner ID')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Private')),
              DataColumn(label: Text('Game ID')),
              DataColumn(label: Text('Nb Players')),
              DataColumn(label: Text('Created At')),
              DataColumn(label: Text('Updated At')),
              DataColumn(label: Text('Upvotes')),
              DataColumn(label: Text('Actions')),
            ],
            rows: state.tournaments.map((tournament) {
              return DataRow(cells: [
                DataCell(Text(tournament.id.toString())),
                DataCell(Text(tournament.name)),
                DataCell(Text(tournament.description)),
                DataCell(Text(tournament.startDate.toIso8601String())),
                DataCell(Text(tournament.endDate.toIso8601String())),
                DataCell(Text(tournament.location)),
                DataCell(Text(tournament.latitude.toString())),
                DataCell(Text(tournament.longitude.toString())),
                DataCell(Text(tournament.ownerId.toString())),
                DataCell(Text(tournament.image)),
                DataCell(Text(tournament.isPrivate.toString())),
                DataCell(Text(tournament.game.name)),
                DataCell(Text(tournament.teams.length.toString())), // Nombre d'équipes
                DataCell(Text(tournament.startDate.toIso8601String())), // Example for Created At, update according to your data
                DataCell(Text(tournament.endDate.toIso8601String())), // Example for Updated At, update according to your data
                DataCell(Text(tournament.upvotes.toString())),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showTournamentDialog(context, tournament: tournament as Tournament?);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          state.tournaments.remove(tournament); // Mettez à jour l'état des tournois ici
                        });
                      },
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }


  Widget _buildGamesContent(DashboardLoaded state) {
    final ScrollController scrollController = ScrollController();

    return Center(
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Tags')),
              DataColumn(label: Text('Created At')),
              DataColumn(label: Text('Updated At')),
              DataColumn(label: Text('Actions')),
            ],
            rows: games.map((game) {
              return DataRow(cells: [
                DataCell(Text(game.id.toString())),
                DataCell(Text(game.name)),
                DataCell(Text(game.description)),
                DataCell(Text(game.image)),
                DataCell(Text(game.tags)),
                DataCell(Text(game.createdAt)),
                DataCell(Text(game.updatedAt)),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showGameDialog(context, game: game);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          games.remove(game);
                        });
                      },
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildUsersContent(DashboardLoaded state) {
    return const Center(child: Text('Users Content'));
  }

  void _showGameDialog(BuildContext context, {Game? game}) {
    final TextEditingController nameController =
    TextEditingController(text: game?.name);
    final TextEditingController descriptionController =
    TextEditingController(text: game?.description);
    final TextEditingController imageController =
    TextEditingController(text: game?.image);
    final TextEditingController tagsController =
    TextEditingController(text: game?.tags);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(game == null ? 'Add Game' : 'Edit Game'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image'),
                ),
                TextField(
                  controller: tagsController,
                  decoration: const InputDecoration(labelText: 'Tags'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (game == null) {
                    games.add(Game(
                      id: games.length + 1,
                      name: nameController.text,
                      description: descriptionController.text,
                      image: imageController.text,
                      tags: tagsController.text,
                      createdAt: DateTime.now().toString(),
                      updatedAt: DateTime.now().toString(),
                    ));
                  } else {
                    game.name = nameController.text;
                    game.description = descriptionController.text;
                    game.image = imageController.text;
                    game.tags = tagsController.text;
                    game.updatedAt = DateTime.now().toString();
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showTournamentDialog(BuildContext context, {Tournament? tournament}) {
    final TextEditingController nameController =
    TextEditingController(text: tournament?.name);
    final TextEditingController descriptionController =
    TextEditingController(text: tournament?.description);
    final TextEditingController startDateController =
    TextEditingController(text: tournament?.startDate);
    final TextEditingController endDateController =
    TextEditingController(text: tournament?.endDate);
    final TextEditingController locationController =
    TextEditingController(text: tournament?.location);
    final TextEditingController latitudeController =
    TextEditingController(text: tournament?.latitude.toString());
    final TextEditingController longitudeController =
    TextEditingController(text: tournament?.longitude.toString());
    final TextEditingController ownerIdController =
    TextEditingController(text: tournament?.ownerId.toString());
    final TextEditingController imageController =
    TextEditingController(text: tournament?.image);
    final TextEditingController privateController =
    TextEditingController(text: tournament?.private.toString());
    final TextEditingController gameIdController =
    TextEditingController(text: tournament?.gameId.toString());
    final TextEditingController nbPlayerController =
    TextEditingController(text: tournament?.nbPlayer.toString());
    final TextEditingController upvotesController =
    TextEditingController(text: tournament?.upvotes.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tournament == null ? 'Add Tournament' : 'Edit Tournament'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                ),
                TextField(
                  controller: endDateController,
                  decoration: const InputDecoration(labelText: 'End Date'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: latitudeController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                ),
                TextField(
                  controller: longitudeController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                ),
                TextField(
                  controller: ownerIdController,
                  decoration: const InputDecoration(labelText: 'Owner ID'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image'),
                ),
                TextField(
                  controller: privateController,
                  decoration: const InputDecoration(labelText: 'Private'),
                ),
                TextField(
                  controller: gameIdController,
                  decoration: const InputDecoration(labelText: 'Game ID'),
                ),
                TextField(
                  controller: nbPlayerController,
                  decoration: const InputDecoration(labelText: 'Nb Players'),
                ),
                TextField(
                  controller: upvotesController,
                  decoration: const InputDecoration(labelText: 'Upvotes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (tournament == null) {
                    tournaments.add(Tournament(
                      id: tournaments.length + 1,
                      name: nameController.text,
                      description: descriptionController.text,
                      startDate: startDateController.text,
                      endDate: endDateController.text,
                      location: locationController.text,
                      latitude: double.parse(latitudeController.text),
                      longitude: double.parse(longitudeController.text),
                      ownerId: int.parse(ownerIdController.text),
                      image: imageController.text,
                      private: privateController.text.toLowerCase() == 'true',
                      gameId: int.parse(gameIdController.text),
                      nbPlayer: int.parse(nbPlayerController.text),
                      createdAt: DateTime.now().toString(),
                      updatedAt: DateTime.now().toString(),
                      upvotes: int.parse(upvotesController.text),
                    ));
                  } else {
                    tournament.name = nameController.text;
                    tournament.description = descriptionController.text;
                    tournament.startDate = startDateController.text;
                    tournament.endDate = endDateController.text;
                    tournament.location = locationController.text;
                    tournament.latitude = double.parse(latitudeController.text);
                    tournament.longitude = double.parse(longitudeController.text);
                    tournament.ownerId = int.parse(ownerIdController.text);
                    tournament.image = imageController.text;
                    tournament.private = privateController.text.toLowerCase() == 'true';
                    tournament.gameId = int.parse(gameIdController.text);
                    tournament.nbPlayer = int.parse(nbPlayerController.text);
                    tournament.updatedAt = DateTime.now().toString();
                    tournament.upvotes = int.parse(upvotesController.text);
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
