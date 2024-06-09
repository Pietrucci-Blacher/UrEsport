import 'package:flutter/material.dart';
import 'package:uresport/services/network_services.dart';
import 'package:uresport/services/notification_service.dart';
import 'package:provider/provider.dart';

class InviteButton extends StatefulWidget {
  final String username;

  const InviteButton({super.key, required this.username});

  @override
  _InviteButtonState createState() => _InviteButtonState();
}

class _InviteButtonState extends State<InviteButton> {
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
              title: Text('Username ${widget.username}'),
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
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    String tournamentId = _tournamentIdController.text;
                    if (tournamentId.isNotEmpty) {
                      inviteUserToTournament(tournamentId, widget.username, (message, isError) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: isError ? Colors.red : Colors.green,
                            ),
                          );

                          if (!isError) {
                            Provider.of<NotificationService>(context, listen: false).addNotification(
                              'Invitation envoyée à ${widget.username} pour le tournoi $tournamentId',
                              'https://via.placeholder.com/150',
                            );
                          }
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
                  child: const Text('Envoyer l\'invitation'),
                ),
              ],
            );
          },
        );
      },
      child: Text('Inviter ${widget.username}'),
    );
  }
}
