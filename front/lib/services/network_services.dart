import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/cache_service.dart';

Future<void> inviteUserToTournament(String tournamentId, String username, Function callback) async {
  try {
    String? token = await CacheService.instance.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.post(
      Uri.parse('${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/invite'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      callback('Invitation envoyée à $username', false);
    } else {
      throw Exception('Failed to invite $username to tournament');
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error: $error');
    }
    callback('Erreur lors de l\'invitation à $username et du tournoi $tournamentId', true);
  }
}

Future<void> joinTournament(String tournamentId, String username, Function callback) async {
  try {
    String? token = await CacheService.instance.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.post(
      Uri.parse('${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/join'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      callback('Vous avez rejoint le tournoi avec succès', false);
    } else if (response.statusCode == 403) {
      callback('Vous n\'êtes pas invité à ce tournoi', true);
    } else {
      throw Exception('Ce tournoi est privé ou complet');
    }
  } catch (error) {
    callback('Erreur lors de la tentative de rejoindre le tournoi $tournamentId'' ou Ce tournoi est privé ou complet', true);
  }
}
