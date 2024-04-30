import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/auth/services/auth_service.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings? settings, BuildContext context) {
    final authService = Provider.of<IAuthService>(context, listen: false);

    if (settings == null) {
      return null;
    }

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/tournament':
        return MaterialPageRoute(builder: (_) => const TournamentScreen());
      case '/notification':
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen(authService: authService));
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