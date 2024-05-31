import 'package:flutter/material.dart';
import 'package:uresport/services/network_services.dart'; // Assurez-vous d'importer les services nécessaires

class JoinButton extends StatefulWidget {
  final String username;

  const JoinButton({Key? key, required this.username}) : super(key: key);

  @override
  _JoinButtonState createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  late TextEditingController _tournamentIdController;

  @override
  void initState() {
    super.initState();
    _tournamentIdController = TextEditingController();
  }

  @override
  void dispose() {
    _tournamentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Rejoindre le tournoi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _tournamentIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID du tournoi',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    String tournamentId = _tournamentIdController.text;
                    if (tournamentId.isNotEmpty) {
                      joinTournament(tournamentId, widget.username, (message, isError) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: isError ? Colors.red : Colors.green,
                            ),
                          );
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez saisir l\'ID du tournoi'),
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Rejoindre le tournoi'),
                ),
              ],
            );
          },
        );
      },
      child: Text('Rejoindre le tournoi'),
    );
  }
}
