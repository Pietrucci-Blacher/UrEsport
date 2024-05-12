import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> inviteUserToTournament(String tournamentId, String username, BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/tournaments/$tournamentId/invite'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
    }),
  );

  if (response.statusCode == 200) {
    // Affichez un SnackBar pour indiquer que l'invitation a été envoyée
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invitation envoyée à $username'),
      ),
    );
  } else {
    throw Exception('Failed to invite user to tournament');
  }
}