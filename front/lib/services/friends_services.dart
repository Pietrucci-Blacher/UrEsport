// services/friend_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/friend.dart';

class FriendService {
  static Future<List<Friend>> fetchFriends() async {
    const int userId = 21; // Utilisateur fixe
    final response = await http.get(Uri.parse('${dotenv.env['API_ENDPOINT']}/users/$userId/friends'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((friend) => Friend.fromJson(friend)).toList();
    } else {
      throw Exception('Failed to load friends');
    }
  }

  static Future<void> updateFavoriteStatus(int userId, int friendId, bool isFavorite) async {
    final response = await http.patch(
      Uri.parse('${dotenv.env['API_ENDPOINT']}/users/$userId/friends/$friendId?favorite=$isFavorite'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update favorite status');
    }
  }

  static Future<void> deleteFriend(int currentUserId, int id) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_ENDPOINT']}/users/$currentUserId/friends/$id'),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete friend');
    }
  }

}
