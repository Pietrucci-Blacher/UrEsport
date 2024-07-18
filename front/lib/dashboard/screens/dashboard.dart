import 'package:flutter/material.dart';
// import 'package:uresport/core/services/tournament_service.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/users_screen.dart';
// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_chart_app/presentation/widgets/indicator.dart';

import 'add_game_page.dart';
import 'add_tournament_page.dart';
import 'edit_game_page.dart';
import 'edit_tournament_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final Websocket ws = Websocket.getInstance();
  int _loggedUsers = 0;
  int _annonUsers = 0;
  int _totalUsers = 0;
  int touchedIndex = -1;

  void _websocket() {
    ws.on('user:connected', (socket, data) {
      setState(() {
        _loggedUsers = data['loggedUsers'];
        _annonUsers = data['annonUsers'];
        _totalUsers = data['totalUsers'];
      });
    });

    ws.emit('user:get-nb', null);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(AuthCheckRequested());
    _websocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () async {
                final currentContext = context;
                final result = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return const AddTournamentPage();
                  },
                );

                if (result == true) {
                  // Fetch updated tournaments
                  if (currentContext.mounted) {
                    BlocProvider.of<DashboardBloc>(context)
                        .add(FetchTournaments());
                  }
                }
              },
              child: const Icon(Icons.add),
            )
          : _selectedIndex == 3
              ? FloatingActionButton(
                  onPressed: () async {
                    final currentContext = context;
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return const AddGamePage();
                      },
                    );

                    if (result == true) {
                      if (currentContext.mounted) {
                        BlocProvider.of<DashboardBloc>(context)
                            .add(FetchGames());
                      }
                    }
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }

  Widget _buildDashboardContent(DashboardLoaded state) {
    return Center(
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Logged Users'),
                    Text(
                      '$_loggedUsers',
                      style: const TextStyle(fontSize: 24),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Annonymous Users'),
                    Text(
                      '$_annonUsers',
                      style: const TextStyle(fontSize: 24),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subscribed Users'),
                    Text(
                      '$_totalUsers',
                      style: const TextStyle(fontSize: 24),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Logged User',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Annonymous User',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Subscribed User',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Text('test'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Text('test'),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    var total = _loggedUsers + _annonUsers + _totalUsers;
    var loggedUsersPercentage = double.parse((_loggedUsers / total * 100).toStringAsFixed(2));
    var annonUsersPercentage = double.parse((_annonUsers / total * 100).toStringAsFixed(2));
    var totalUsersPercentage = double.parse((_totalUsers / total * 100).toStringAsFixed(2));
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: loggedUsersPercentage,
            title: '$loggedUsersPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: annonUsersPercentage,
            title: '$annonUsersPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: totalUsersPercentage,
            title: '$totalUsersPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
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

    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: scrollController,
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
                DataColumn(label: Text('Nb Players')),
                DataColumn(label: Text('Created At')),
                DataColumn(label: Text('Updated At')),
                DataColumn(label: Text('Upvotes')),
                DataColumn(label: Text('')), // Empty column for spacing
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
                  DataCell(Text(tournament.nbPlayers.toString())),
                  DataCell(Text(tournament.startDate.toIso8601String())),
                  DataCell(Text(tournament.endDate.toIso8601String())),
                  DataCell(Text(tournament.upvotes.toString())),
                  DataCell(Container()), // Empty cell for spacing
                ]);
              }).toList(),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: SizedBox(
            width: 100, // Set the width for the fixed column
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Actions')),
              ],
              rows: state.tournaments.map((tournament) {
                return DataRow(cells: [
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditTournamentPage(
                                      tournament: tournament)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                context, tournament.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGamesContent(DashboardLoaded state) {
    final ScrollController scrollController = ScrollController();

    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: scrollController,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Image URL')),
                DataColumn(label: Text('Tags')),
                DataColumn(label: Text('Created At')),
                DataColumn(label: Text('Updated At')),
                DataColumn(label: Text('')), // Empty column for spacing
              ],
              rows: state.games.map((game) {
                return DataRow(cells: [
                  DataCell(Text(game.id.toString())),
                  DataCell(Text(game.name)),
                  DataCell(Text(game.description)),
                  DataCell(Text(game.imageUrl)),
                  DataCell(Text(game.tags.join(', '))),
                  DataCell(Text(game.createdAt)),
                  DataCell(Text(game.updatedAt)),
                  DataCell(Container()), // Empty cell for spacing
                ]);
              }).toList(),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: SizedBox(
            width: 100, // Set the width for the fixed column
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Actions')),
              ],
              rows: state.games.map((game) {
                return DataRow(cells: [
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditGamePage(game: game)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, game.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int gameId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Builder(
          builder: (BuildContext innerContext) {
            return AlertDialog(
              title: const Text('Delete Game'),
              content: const Text('Are you sure you want to delete this game?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Utilisez innerContext pour accéder à DashboardBloc
                    BlocProvider.of<DashboardBloc>(innerContext)
                        .add(DeleteGameEvent(gameId));
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildUsersContent(DashboardLoaded state) {
    return const Center(child: Text('Users Content'));
  }
}
