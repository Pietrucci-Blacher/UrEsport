import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/friend.dart';
import 'package:uresport/core/services/cache_service.dart';

abstract class IFriendService {
  Future<List<Friend>> fetchFriends(int currentUserId);
  Future<void> addFriend(int currentUserId, int friendId);
  Future<void> updateFavoriteStatus(int userId, int friendId, bool isFavorite);
  Future<void> deleteFriend(int currentUserId, int id);
}

class FriendService implements IFriendService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  FriendService(this._dio);

  @override
  Future<List<Friend>> fetchFriends(int currentUserId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    final response = await _dio.get(
      "${dotenv.env['API_ENDPOINT']}/users/$currentUserId/friends",
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = response.data;
      if (jsonResponse is String) {
        jsonResponse = json.decode(jsonResponse);
      }
      if (jsonResponse is Map<String, dynamic>) {
        List<Friend> allFriends = [];

        if (jsonResponse.containsKey('favorites')) {
          List<dynamic> favoritesList = jsonResponse['favorites'];
          allFriends.addAll(favoritesList
              .map((friend) => Friend.fromJson(friend, isFavorite: true)));
        }

        if (jsonResponse.containsKey('friends')) {
          List<dynamic> friendsList = jsonResponse['friends'];
          allFriends.addAll(friendsList
              .map((friend) => Friend.fromJson(friend, isFavorite: false)));
        }

        return allFriends;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load friends');
    }
  }

  Future<bool> isFriend(int currentUserId, int friendId) async {
    final friends = await fetchFriends(currentUserId);
    return friends.any((friend) => friend.id == friendId);
  }

  @override
  Future<void> addFriend(int currentUserId, int friendId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    final response = await _dio.post(
      "${dotenv.env['API_ENDPOINT']}/users/$currentUserId/friends/$friendId",
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Erreur lors de l\'ajout de l\'ami ou ami déjà ajouté',
      );
    }
  }

  @override
  Future<void> updateFavoriteStatus(
      int userId, int friendId, bool isFavorite) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    final response = await _dio.patch(
      "${dotenv.env['API_ENDPOINT']}/users/$userId/friends/$friendId?favorite=$isFavorite",
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update favorite status');
    }
  }

  @override
  Future<void> deleteFriend(int currentUserId, int id) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    final response = await _dio.delete(
      "${dotenv.env['API_ENDPOINT']}/users/$currentUserId/friends/$id",
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete friends');
    }
  }
}
