import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';
import 'package:uresport/core/services/auth_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const TournamentScreen(),
    const NotificationScreen(),
    Consumer<IAuthService>(
      builder: (context, authService, _) => ProfileScreen(authService: authService),
    ),
  ];

  void _onItemTapped(int index) {
    if (index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Provider.of<IAuthService>(context, listen: false).isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          bool isLoggedIn = snapshot.data ?? false;
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
