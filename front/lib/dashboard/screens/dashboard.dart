import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/cubit/locale_cubit.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/users_screen.dart';
import 'package:uresport/shared/locale_switcher.dart';

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
  List<Game> _topGames = [];
  int _activeTournaments = 0;
  int _topGamesCount = 5;
  late final DashboardBloc _dashboardBloc;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(AuthCheckRequested());
    _websocket();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authService = context.read<IAuthService>();
    final tournamentService = context.read<ITournamentService>();
    final gameService = context.read<IGameService>();

    _dashboardBloc = DashboardBloc(
      Websocket.getInstance(),
      authService as AuthService,
      tournamentService as TournamentService,
      gameService as GameService,
    )..add(ConnectWebSocket());

    BlocProvider.of<AuthBloc>(context).add(AuthCheckRequested());
  }

  void _websocket() {
    ws.on('user:connected', (socket, data) {
      setState(() {
        _loggedUsers = data['loggedUsers'];
        _annonUsers = data['annonUsers'];
        _totalUsers = data['totalUsers'];
      });
    });

    ws.on('games:top', (socket, data) {
      setState(() {
        _topGames = (data as List).map((game) => Game.fromJson(game)).toList();
      });
    });

    ws.on('tournaments:active', (socket, data) {
      setState(() {
        _activeTournaments = data['count'];
      });
    });

    ws.emit('user:get-nb', null);
    ws.emit('games:get-top', {'limit': _topGamesCount});
    ws.emit('tournaments:get-active', null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: LocaleSwitcher(
                onLocaleChanged: (locale) {
                  context.read<LocaleCubit>().setLocale(locale);
                },
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            const VerticalDivider(thickness: 1, width: 1),
            _buildSidebar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardInitial) {
                      return const Center(child: Text('Initializing...'));
                    } else if (state is DashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DashboardLoaded) {
                      return _buildContent(state);
                    } else if (state is DashboardError) {
                      return Center(child: Text('Error: ${state.error}'));
                    }
                    return const Center(child: Text('Unknown state'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
                _buildNavItem(1, 'Feature Flippings', Icons.tune),
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

  Widget _buildContent(DashboardLoaded state) {
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
        return const UsersPage();
      default:
        return const Center(child: Text('Unknown page'));
    }
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
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
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
    var loggedUsersPercentage =
        double.parse((_loggedUsers / total * 100).toStringAsFixed(2));
    var annonUsersPercentage =
        double.parse((_annonUsers / total * 100).toStringAsFixed(2));
    var totalUsersPercentage =
        double.parse((_totalUsers / total * 100).toStringAsFixed(2));
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
    return const Center(child: Text('Tournaments Content'));
  }

  Widget _buildGamesContent(DashboardLoaded state) {
    return const Center(child: Text('Games Content'));
  }

  Widget _buildTopGamesCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Top Games',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: _topGamesCount,
                  items: [5, 10, 15, 20].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('Top $value'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _topGamesCount = newValue;
                        ws.emit('games:get-top', {'limit': _topGamesCount});
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _topGames.length,
                itemBuilder: (context, index) {
                  final game = _topGames[index];
                  return ListTile(
                    leading: Text('${index + 1}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    title: Text(game.name),
                    trailing: Chip(
                      label: Text('${game.upvotes} upvotes'),
                      backgroundColor: Colors.blue[100],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Game {
  final String name;
  final int upvotes;

  Game({required this.name, required this.upvotes});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'],
      upvotes: json['upvotes'],
    );
  }
}

class _Badge extends StatelessWidget {
  final String title;
  final double size;
  final Color borderColor;

  const _Badge(
    this.title, {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(
          title[0].toUpperCase(),
          style: TextStyle(
            fontSize: size * .3,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
