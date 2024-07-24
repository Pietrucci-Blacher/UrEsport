import 'package:flutter/material.dart';

import 'package:uresport/l10n/app_localizations.dart';

class JoinButton extends StatelessWidget {
  final String username;
  final String tournamentId;

  const JoinButton({
    super.key,
    required this.username,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    return ElevatedButton(
      onPressed: () => _showJoinDialog(context, _attemptJoinTournament()),
      child: Text(l.joinButton),
    );
  }

  bool _attemptJoinTournament() {
    return true;
  }

  void _showJoinDialog(BuildContext context, bool joinSuccess) {
    AppLocalizations l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(joinSuccess ? l.success : l.failure),
          content: Text(
            joinSuccess ? l.joinedTournament : l.joinError,
          ),
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
