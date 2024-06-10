import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/auth/screens/auth_screen.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';
import 'package:uresport/game/screens/game_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uresport/cubit/locale_cubit.dart';
import 'package:uresport/shared/locale_switcher.dart';
import 'package:uresport/provider/NotificationProvider.dart';

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
      if (index == 2) {
        // Clear notification count when navigating to notifications tab
        Provider.of<NotificationProvider>(context, listen: false);
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(widget.authService)..add(AuthCheckRequested()),
      child: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          return BlocBuilder<AuthBloc, AuthState>(
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
                    title: Row(
                      children: [
                        if (!kIsWeb)
                          IconButton(
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
                                    builder: (context) => ProfileScreen(
                                        authService: widget.authService),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AuthScreen(
                                      authService: widget.authService,
                                      showLogin: true,
                                      showRegister: !kIsWeb,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        const SizedBox(width: 8),
                        Text(
                          _getTitleForIndex(context, _selectedIndex),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    actions: [
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              // Logic to open notifications screen
                            },
                          ),
                          if (notificationProvider.notificationCount > 0)
                            Positioned(
                              right: 11,
                              top: 11,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${notificationProvider.notificationCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      LocaleSwitcher(
                        onLocaleChanged: (locale) {
                          context.read<LocaleCubit>().setLocale(locale);
                        },
                      ),
                    ],
                  ),
                  body: IndexedStack(
                    index: _selectedIndex,
                    children: _widgetOptions,
                  ),
                  bottomNavigationBar: kIsWeb
                      ? null
                      : CustomBottomNavigation(
                          isLoggedIn: isLoggedIn,
                          selectedIndex: _selectedIndex,
                          onTap: _onItemTapped,
                          notificationCount: notificationProvider.notificationCount, // Pass the count here
                        ),
                );
              }
            },
          );
        },
      ),
    );
  }


  String _getTitleForIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context).homeScreenTitle;
      case 1:
        return AppLocalizations.of(context).gameScreenTitle;
      case 2:
        return AppLocalizations.of(context).tournamentScreenTitle;
      case 3:
        return AppLocalizations.of(context).notificationScreenTitle;
      default:
        return '';
    }
  }
}