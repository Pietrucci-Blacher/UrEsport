import 'package:flutter/material.dart';
import 'package:uresport/l10n/app_localizations.dart';
import '../../widgets/custom_bracket.dart'; // Assurez-vous de modifier le chemin d'importation selon votre structure de projet
import '../../widgets/custom_poules.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).homeScreenWelcome),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TournamentBracketPage()),
                );
              },
              child: Text('Custom Bracket'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomPoulesPage()),
                );
              },
              child: Text('Custom Poules'),
            ),
          ],
        ),
      ),
    );
  }
}
