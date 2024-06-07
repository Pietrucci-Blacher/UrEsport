// services/friend_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/friend.dart';

class FriendService {
  static Future<List<Friend>> fetchFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //int userId = prefs.getInt('userId') ?? 0;
    const int userId = 21; // Utilisateur fixe


    final response = await http.get(Uri.parse('${dotenv.env['API_ENDPOINT']}/users/$userId/friends'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((friend) => Friend.fromJson(friend)).toList();
    } else {
      throw Exception('Failed to load friends');
    }
  }
}
