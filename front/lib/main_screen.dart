import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/widgets/games_screen.dart';
import 'package:uresport/widgets/invite_button.dart';
import 'package:uresport/widgets/join_button.dart';
import 'package:uresport/widgets/qrcode.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(AuthCheckRequested());

    // Obtenez authService depuis Provider
    final authService = Provider.of<IAuthService>(context, listen: false);

    _widgetOptions = [
      const HomeScreen(),
      const TournamentScreen(),
      const NotificationScreen(),
      ProfileScreen(authService: authService),
      const QRCode(
             width: 200,
             height: 200,
             data: 'https://flutterflow.io', // Remplacez par les données que vous voulez encoder
           ),// Pass authService here
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> usernames = ['user1', 'user2', 'user3', 'user4'];
    String tournamentId = '1'; // Replace this with the actual tournamentId

    List<Widget> inviteButtons = usernames.map((username) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(username),
        Row(
          children: [
            InviteButton(
              username: username,
              tournamentId: tournamentId,
            ),
            JoinButton(
              username: username,
              tournamentId: tournamentId,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GamesScreen()),
                );
              },
              child: Text('Voir les jeux'),
            )
          ],
        ),
      ],
    )).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('UrEsport'),
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
          ),
          Expanded(
            child: ListView(
              children: inviteButtons,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        isLoggedIn: isLoggedIn,
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          bool isLoggedIn = state is AuthAuthenticated;
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
            bottomNavigationBar: CustomBottomNavigation(
              isLoggedIn: isLoggedIn,
              selectedIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}
