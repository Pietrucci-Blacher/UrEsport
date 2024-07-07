import 'package:flutter/material.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/main_screen.dart';

class RouteGenerator {
  final IAuthService authService;

  RouteGenerator(this.authService);

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case '/games':
        return MaterialPageRoute(
          builder: (_) => MainScreen(
            authService: authService,
            initialIndex: 1,
          ),
          settings: settings,
        );
      case '/tournaments':
        return MaterialPageRoute(
          builder: (_) => MainScreen(
            authService: authService,
            initialIndex: 2,
          ),
          settings: settings,
        );
      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => MainScreen(
            authService: authService,
            initialIndex: 3,
          ),
          settings: settings,
        );
      default:
        return _errorRoute();
    }
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found!')),
      );
    });
  }
}
