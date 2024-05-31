import 'package:flutter/material.dart';

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
    return ElevatedButton(
      onPressed: () => _showJoinDialog(context, _attemptJoinTournament()),
      child: const Text('Rejoindre'),
    );
  }

  bool _attemptJoinTournament() {
    return true;
  }

  void _showJoinDialog(BuildContext context, bool joinSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(joinSuccess ? 'Succès' : 'Échec'),
          content: Text(
            joinSuccess ? 'Vous avez bien rejoint le tournoi !' : 'Impossible de rejoindre le tournoi.',
          ),
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
