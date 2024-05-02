import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class InviteButton extends StatelessWidget {
  final String username;
  final int tournamentId;

  const InviteButton({
    super.key,
    this.username = 'ilies.slim2', // Valeur par défaut pour username
    this.tournamentId = 1, // Valeur par défaut pour tournamentId
  });

  //const InviteButton({Key? key, required this.username, required this.tournamentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var response = await inviteUserToTournament(tournamentId, username);
                if (response.statusCode == 200) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Invitation Status'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('User: $username'),
                            Text('URL: http://localhost:8080/tournaments/$tournamentId/invite'),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Failed to invite user.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Invite User to Tournament'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isPresent = await checkUserPresence(username);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Check User Presence'),
                      content: Text(isPresent ? 'Checkin success' : 'Checkin error'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Check User Presence'),
            ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> inviteUserToTournament(int tournamentId, String username) {
    return http.post(
      Uri.parse('http://localhost:8080/tournaments/$tournamentId/invite'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );
  }

  Future<bool> checkUserPresence(String username) async {
    // Ici, vous devez implémenter la logique pour vérifier la présence de l'utilisateur.
    // Pour l'exemple, nous retournons simplement true.
    return true;
  }
}
