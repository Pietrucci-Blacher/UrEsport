import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/auth/screens/auth_screen.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/cubit/locale_cubit.dart';
import 'package:uresport/game/screens/game_screen.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/shared/locale_switcher.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/shared/provider/notification_provider.dart';
import 'package:uresport/shared/utils/image_util.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';

class MainScreen extends StatefulWidget {
  final IAuthService authService;
  final int initialIndex;

  const MainScreen({
    super.key,
    required this.authService,
    this.initialIndex = 0,
  });

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late final List<Widget> _widgetOptions;
  String? _profileImageUrl;
  final ValueNotifier<String?> _profileImageNotifier =
  ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _widgetOptions = [
      const HomeScreen(),
      const GamesScreen(),
      const TournamentScreen(),
      const NotificationScreen(),
    ];

    _profileImageNotifier.addListener(() {
      if (_profileImageNotifier.value != null) {
        setState(() {
          _profileImageUrl = _profileImageNotifier.value;
        });
      }
    });
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
      create: (context) =>
      AuthBloc(widget.authService)..add(AuthCheckRequested()),
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
                if (isLoggedIn &&
                    state.user.profileImageUrl != _profileImageUrl) {
                  _profileImageUrl = state.user.profileImageUrl;
                }
                return ValueListenableBuilder<String?>(
                  valueListenable: _profileImageNotifier,
                  builder: (context, value, child) {
                    if (value != null) {
                      _profileImageUrl = value;
                    }
                    return Scaffold(
                      appBar: AppBar(
                        title: Row(
                          children: [
                            const SizedBox(width: 8),
                            Text(
                              _getTitleForIndex(context, _selectedIndex),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        actions: [
                          if (!kIsWeb)
                            IconButton(
                              icon: isLoggedIn && _profileImageUrl != null
                                  ? Stack(
                                children: [
                                  ClipOval(
                                    child: CachedImageWidget(
                                      url: _profileImageUrl!,
                                      size: 40,
                                    ),
                                  ),
                                  if (notificationProvider
                                      .notificationCount >
                                      0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        constraints:
                                        const BoxConstraints(
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
                              )
                                  : const Icon(Icons.person),
                              onPressed: () async {
                                if (isLoggedIn) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        authService: widget.authService,
                                        profileImageNotifier:
                                        _profileImageNotifier,
                                      ),
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
                          LocaleSwitcher(
                            onLocaleChanged: (locale) {
                              context.read<LocaleCubit>().setLocale(locale);
                            },
                          ),
                        ],
                      ),
                      drawer: Drawer(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            DrawerHeader(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isLoggedIn && _profileImageUrl != null)
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                      NetworkImage(_profileImageUrl!),
                                    )
                                  else if (isLoggedIn)
                                    CircleAvatar(
                                      radius: 40,
                                      child: Text(
                                        state.user.username[0].toUpperCase(),
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    )
                                  else
                                    const CircleAvatar(
                                      radius: 40,
                                      child: Icon(Icons.person),
                                    ),
                                  const SizedBox(height: 8),
                                  if (isLoggedIn)
                                    Text(
                                      state.user.username,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('Profile'),
                              onTap: () async {
                                Navigator.pop(context); // Close the drawer
                                if (isLoggedIn) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        authService: widget.authService,
                                        profileImageNotifier:
                                        _profileImageNotifier,
                                      ),
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
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('Settings'),
                              onTap: () {
                                // Implement the navigation to Settings screen here
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text('Logout'),
                              onTap: () {
                                // Implement the logout functionality here
                              },
                            ),
                          ],
                        ),
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
                        notificationCount:
                        notificationProvider.notificationCount,
                      ),
                    );
                  },
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
