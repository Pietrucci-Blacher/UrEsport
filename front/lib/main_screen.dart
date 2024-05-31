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
import 'package:uresport/widgets/qrcode.dart';
import 'package:uresport/widgets/user_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

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

    // Obtain authService from Provider
    final authService = Provider.of<IAuthService>(context, listen: false);

    _widgetOptions = [
      const HomeScreen(),
      const TournamentScreen(),
      const NotificationScreen(),
      ProfileScreen(authService: authService),
      const QRCode(
        width: 200,
        height: 200,
        data: 'https://flutterflow.io', // Replace with the data you want to encode
      ), // Pass authService here
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          bool isLoggedIn = state is AuthAuthenticated;
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamesScreen()),
                    );
                  },
                  child: Text('Voir les jeux'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserList()),
                    );
                  },
                  child: Text('Voir les utilisateurs'),
                ),
              ],
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
