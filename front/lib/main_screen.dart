import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';
import 'package:uresport/game/screens/game_screen.dart';
import 'package:uresport/auth/screens/login_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/core/services/auth_service.dart';

class MainScreen extends StatefulWidget {
  final IAuthService authService;

  const MainScreen({super.key, required this.authService});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      const HomeScreen(),
      const GamesScreen(),
      const TournamentScreen(),
      const NotificationScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(widget.authService)..add(AuthCheckRequested()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            bool isLoggedIn = state is AuthAuthenticated;
            String? profileImageUrl;
            if (isLoggedIn) {
              profileImageUrl = state.user.profileImageUrl;
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('My App'),
                leading: IconButton(
                  icon: isLoggedIn && profileImageUrl != null
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl),
                  )
                      : const Icon(Icons.person),
                  onPressed: () {
                    if (isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(authService: widget.authService),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(authService: widget.authService),
                        ),
                      );
                    }
                  },
                ),
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
      ),
    );
  }
}
