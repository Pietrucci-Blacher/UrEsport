import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:uresport/models/friend.dart';
import 'package:uresport/core/services/cache_service.dart';

abstract class IFriendService {
  Future<List<Friend>> fetchFriends(int userId);
  Future<void> addFriend(int currentUserId, int friendId);
  Future<void> updateFavoriteStatus(int userId, int friendId, bool isFavorite);
  Future<void> deleteFriend(int currentUserId, int id);
}

class FriendService implements IFriendService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  FriendService(this._dio);

  @override
  Future<List<Friend>> fetchFriends(int userId) async {
    try {
      final token = await _cacheService.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/users/$userId/friends",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        if (jsonResponse is String) {
          jsonResponse = json.decode(jsonResponse);
        }
        if (jsonResponse is List) {
          return jsonResponse.map((friend) => Friend.fromJson(friend)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        print('Code error: ${response.statusCode}');
        throw Exception('Failed to load friends');
      }
    } catch (e) {
      throw Exception('Failed to load friends: $e');
    }
  }

  @override
  Future<void> addFriend(int currentUserId, int friendId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.post(
        "/users/$currentUserId/friends/$friendId",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode != 200) {
        throw DioError(
          requestOptions: response.requestOptions,
          response: response,
          type: DioErrorType.response,
          error: 'Erreur lors de l\'ajout de l\'ami ou ami déjà ajouté',
        );
      }
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 409) {
        throw DioError(
          requestOptions: e.requestOptions,
          response: e.response,
          type: DioErrorType.response,
          error: 'Ami déjà ajouté',
        );
      } else {
        throw Exception('Failed to add friend: $e');
      }
    }
  }

  @override
  Future<void> updateFavoriteStatus(int userId, int friendId, bool isFavorite) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
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
    } catch (e) {
      throw Exception('Failed to update favorite status: $e');
    }
  }

  @override
  Future<void> deleteFriend(int currentUserId, int id) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.delete(
        "${dotenv.env['API_ENDPOINT']}/users/$currentUserId/friends/$id",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete friends');
      }
    } catch (e) {
      throw Exception('Failed to delete friends: $e');
    }
  }
}
