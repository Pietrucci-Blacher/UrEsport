import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/cubit/locale_cubit.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/users_screen.dart';
import 'package:uresport/shared/locale_switcher.dart';

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
  int touchedIndex = -1;

  void _websocket() {
    ws.on('user:connected', (socket, data) {
      setState(() {
      });
    });

    ws.emit('user:get-nb', null);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(AuthCheckRequested());
    _websocket();
    BlocProvider.of<DashboardBloc>(context).add(ConnectWebSocket());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildNavItem(0, 'Dashboard', Icons.dashboard),
                _buildNavItem(1, 'Feature Flipping', Icons.tune),
                _buildNavItem(2, 'Logs', Icons.list),
                _buildNavItem(3, 'Tournaments', Icons.emoji_events),
                _buildNavItem(4, 'Games', Icons.games),
                _buildNavItem(5, 'Users', Icons.people),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => setState(() => _selectedIndex = index),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.black),
          ),
          const Spacer(),
          LocaleSwitcher(
            onLocaleChanged: (locale) {
              context.read<LocaleCubit>().setLocale(locale);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          switch (_selectedIndex) {
            case 0:
              return _buildDashboardContent(state);
            case 1:
              return _buildFeatureFlippingConten(state);
            case 2:
              return _buildLogsContent(state);
            case 3:
              return _buildTournamentsContent(state);
            case 4:
              return _buildGamesContent(state);
            case 5:
              return const UsersPage();
            default:
              return const Center(child: Text('Unknown page'));
          }
        } else if (state is DashboardError) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return const Center(child: Text('Unknown state'));
      },
    );
  }

  Widget _buildDashboardContent(DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
                child: _buildStatCard(
                    'Logged Users', state.loggedInUsers, Colors.blue)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildStatCard(
                    'Anonymous Users', state.anonymousUsers, Colors.green)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildStatCard(
                    'Subscribed Users', state.subscribedUsers, Colors.purple)),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildUserChart(state)),
              const SizedBox(width: 16),
              Expanded(child: _buildRecentActivityCard(state)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserChart(DashboardLoaded state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(state),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.blue, 'Logged Users'),
        _buildLegendItem(Colors.green, 'Anonymous Users'),
        _buildLegendItem(Colors.purple, 'Subscribed Users'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildRecentActivityCard(DashboardLoaded state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: state.recentLogs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.recentLogs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(DashboardLoaded state) {
    return [
      _buildPieChartSection(Colors.blue, state.loggedInUsers),
      _buildPieChartSection(Colors.green, state.anonymousUsers),
      _buildPieChartSection(Colors.purple, state.subscribedUsers),
    ];
  }

  PieChartSectionData _buildPieChartSection(Color color, int value) {
    final double fontSize = value > 0 ? 16 : 0;
    final double radius = value > 0 ? 50 : 0;

    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      title: value > 0 ? '$value' : '',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
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


  Widget _buildFeatureFlippingConten(DashboardLoaded state) {
    return const Center(child: Text('Feature Flipping'));
  }

  Widget _buildFloatingActionButton() {
    return _selectedIndex == 4
        ? FloatingActionButton(
      onPressed: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return const AddGamePage();
          },
        );

        if (result == true && mounted) {
          BlocProvider.of<DashboardBloc>(context).add(FetchGames());
        }
      },
      child: const Icon(Icons.add),
    )
        : _selectedIndex == 3
        ? FloatingActionButton(
      onPressed: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return const AddTournamentPage();
          },
        );

        if (result == true && mounted) {
          BlocProvider.of<DashboardBloc>(context).add(FetchTournaments());
        }
      },
      child: const Icon(Icons.add),
    )
        : Container();
  }
}
