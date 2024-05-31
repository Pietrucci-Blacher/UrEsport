import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserService {
  static const String _baseUrl = 'http://10.0.2.2:8080/users';

  static Future<List<User>> fetchUsers({int page = 1, int limit = 10}) async {
    final response = await http.get(Uri.parse('$_baseUrl?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
