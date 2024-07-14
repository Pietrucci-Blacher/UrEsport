import 'package:flutter/material.dart';
// import 'package:uresport/core/services/tournament_service.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/users_screen.dart';
// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_chart_app/presentation/widgets/indicator.dart';

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
    return BlocProvider(
      create: (context) =>
          DashboardBloc(Websocket.getInstance())..add(ConnectWebSocket()),
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
          ],
        ),
      ),
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
    return const Center(child: Text('Tournaments Content'));
  }

  Widget _buildGamesContent(DashboardLoaded state) {
    return const Center(child: Text('Games Content'));
  }
}
