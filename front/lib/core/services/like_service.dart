import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'cache_service.dart';
import 'package:uresport/core/models/like.dart';

abstract class ILikeService {
  Future<List<Like>> fetchLikes();
  Future<Like> getLikeById(int id);
  Future<List<Like>> getLikesByUserID(int userId);
  Future<List<Like>> getLikesByUserIdAndGameId(int userId, int gameId);
  Future<void> createLike(Like like);
  Future<void> deleteLike(int id);
}

class LikeService implements ILikeService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  LikeService(this._dio);

  @override
  Future<List<Like>> fetchLikes() async {
    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/games/likes",
      );

      if (response.statusCode == 200) {
        debugPrint('Likes fetched successfully: ${response.data}');
        final likes = (response.data as List)
            .map((json) => Like.fromJson(json))
            .toList();
        return likes;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load likes',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error fetching likes: $e');
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<Like> getLikeById(int id) async {
    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/likes/$id",
      );

      if (response.statusCode == 200) {
        debugPrint('Like fetched successfully: ${response.data}');
        return Like.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load like',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error fetching like: $e');
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<List<Like>> getLikesByUserID(int userId) async {
    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/likes/user/$userId",
      );

      if (response.statusCode == 200) {
        debugPrint('Likes fetched successfully: ${response.data}');
        List<dynamic> likesJson = response.data;
        return likesJson.map((json) => Like.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load likes',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error fetching likes: $e');
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }


  @override
  Future<List<Like>> getLikesByUserIdAndGameId(int userId, int gameId) async {
    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/likes/user/$userId/game/$gameId",
      );

      if (response.statusCode == 200) {
        debugPrint('Likes fetched successfully: ${response.data}');
        List<dynamic> likesJson = response.data;
        return likesJson.map((json) => Like.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load likes',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error fetching likes: $e');
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<Like> createLike(Like like) async {
    final token = await _cacheService.getString('token');
    try {
      debugPrint('Creating like with data: ${like.toJson()}');
      debugPrint('Token: $token');
      debugPrint('API Endpoint: ${dotenv.env['API_ENDPOINT']}');

      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/likes/",
        data: {'user_id': like.userId, 'game_id': like.gameId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          followRedirects: false,  // Important pour suivre les redirections manuellement
        ),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');
      debugPrint('Response headers: ${response.headers}');
      debugPrint('Response redirect URL: ${response.realUri}');

      if (response.statusCode == 201) {
        return Like.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create like',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error during createLike: $e');
      if (e is DioException) {
        debugPrint('DioException details: ${e.response?.statusCode}, ${e.response?.data}, ${e.response?.headers}');
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<void> deleteLike(int id) async {
    final token = await _cacheService.getString('token');
    try {
      final response = await _dio.delete(
        "${dotenv.env['API_ENDPOINT']}/likes/$id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to delete like',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error during deleteLike: $e');
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }
}

