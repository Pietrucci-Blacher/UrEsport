import 'package:flutter/material.dart';
import 'package:uresport/l10n/app_localizations.dart';
import '../../widgets/custom_bracket.dart'; // Assurez-vous de modifier le chemin d'importation selon votre structure de projet

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).homeScreenWelcome),
      ),
      body: TournamentBracketPage(), // Affiche le widget TournamentBracketPage ici
    );
  }
}
