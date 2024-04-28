import 'package:flutter/material.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';
import 'package:uresport/shared/providers/auth_service.dart';

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
    Builder(
      builder: (context) => ProfileScreen(authService: Provider.of<IAuthService>(context, listen: false)),
    ),
  ];

  void _onItemTapped(int index) {
    if (index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      debugPrint('Index $index is out of range for _widgetOptions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Provider.of<IAuthService>(context, listen: false).isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return const Text('Error checking login status');
        } else {
          bool isLoggedIn = snapshot.data ?? false;
          return Scaffold(
            appBar: AppBar(
              title: const Text('UrEsport'),
            ),
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
