import 'package:flutter/material.dart';
import 'package:uresport/shared/splash_screen/splash_screen.dart';
import 'package:uresport/global_scaffold.dart';
import 'package:uresport/core/services/auth_service.dart';

class SplashScreenHandler extends StatefulWidget {
  final IAuthService authService;

  const SplashScreenHandler({super.key, required this.authService});

  @override
  SplashScreenHandlerState createState() => SplashScreenHandlerState();
}

class SplashScreenHandlerState extends State<SplashScreenHandler> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _isInitialized
            ? GlobalScaffold(authService: widget.authService)
            : const SplashScreen(),
      ),
    );
  }
}
