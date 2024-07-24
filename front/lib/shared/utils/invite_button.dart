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
    AppLocalizations l = AppLocalizations.of(context);
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
              ? l.invitationSentSuccessfully
              : l.invitationSendError),
        ),
      );
    }
  }

  void _showInviteDialog(BuildContext context, {required bool success}) {
    AppLocalizations l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? l.invitationSentSuccessfully: l.invitationSendError),
          content: Text(success
              ? '${l.hello} $username, ${AppLocalizations.of(context).inviteSuccess}'
              : l.inviteError),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.closeButton),
            ),
          ],
        );
      },
    );
  }
}
