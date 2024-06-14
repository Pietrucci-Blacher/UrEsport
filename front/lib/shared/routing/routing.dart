import 'package:flutter/material.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';
import 'package:uresport/game/screens/game_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/game':
        return MaterialPageRoute(builder: (_) => const GamesScreen());
      case '/tournament':
        return MaterialPageRoute(builder: (_) => const TournamentScreen());
      case '/notification':
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found!')),
      );
    });
  }
}
