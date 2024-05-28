// invite_button.dart
import 'package:flutter/material.dart';
import 'package:uresport/services/network_services.dart'; // Assurez-vous d'importer les services nécessaires
import 'package:uresport/l10n/app_localizations.dart';

class InviteButton extends StatelessWidget {
  final String username;
  final String tournamentId;

  const InviteButton({Key? key, required this.username, required this.tournamentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        inviteUserToTournament(tournamentId, username, context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Inviter $username'),
              content: Text('Bonjour $username, ' + AppLocalizations.of(context).inviteSuccessTitle),              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          },
        );
      },
      child: Text(AppLocalizations.of(context).inviteButtonTitle),
    );
  }
}
