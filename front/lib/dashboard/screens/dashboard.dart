import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/users_screen.dart';

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
    return BlocProvider<DashboardBloc>(
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
    return const Center(child: Text('Tournaments Content'));
  }

  Widget _buildGamesContent(DashboardLoaded state) {
    return const Center(child: Text('Games Content'));
  }
}
