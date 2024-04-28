import 'package:flutter/material.dart';
import 'package:uresport/shared/routing/routing.dart';
import 'package:uresport/shared/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UrEsport',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      home: Builder(
        builder: (context) => const SplashScreen(),
      ),
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings, context),
    );
  }
}
