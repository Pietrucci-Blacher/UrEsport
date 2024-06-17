import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/l10n/app_localizations.dart';

class InviteButton extends StatelessWidget {
  final String username;
  final String tournamentId;

  const InviteButton({
    super.key,
    required this.username,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onInvitePressed(context),
      child: Text(AppLocalizations.of(context).inviteButton),
    );
  }

  Future<void> _onInvitePressed(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    bool success = false;

    try {
      final tournamentService = context.read<ITournamentService>();
      await tournamentService.inviteUserToTournament(tournamentId, username);
      success = true;
    } catch (e) {
      success = false;
    }

    if (context.mounted) {
      _showInviteDialog(context, success: success);
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Invitation envoyée avec succès'
              : 'Erreur lors de l\'envoi de l\'invitation'),
        ),
      );
    }
  }

  void _showInviteDialog(BuildContext context, {required bool success}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Invitation envoyée' : 'Erreur'),
          content: Text(success
              ? 'Bonjour $username, ${AppLocalizations.of(context).inviteSuccess}'
              : 'Échec de l\'invitation.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
