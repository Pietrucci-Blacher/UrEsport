import 'package:flutter/material.dart';
import 'package:uresport/l10n/app_localizations.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context).tournamentScreenWelcome),
    );
  }
}
