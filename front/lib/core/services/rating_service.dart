import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/cache_service.dart';

abstract class IRatingService {
  Future<Map<String, dynamic>> getRating(int tournamentId, int userId);
  Future<void> submitRating(int tournamentId, int userId, double rating);
  Future<void> updateRating(int tournamentId, int ratingId, int userId, double rating);
  Future<Map<String, dynamic>> fetchRatingDetails(int tournamentId, int userId);
}

class RatingService implements IRatingService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  RatingService(this._dio);

  @override
  Future<Map<String, dynamic>> getRating(int tournamentId, int userId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/rating",
        data: {
          'tournament_id': tournamentId,
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null && status < 500; // Accepter les codes de statut < 500
          },
        ),
      );

      if (response.statusCode == 200) {
        return {
          'rating': (response.data['rating'] as num).toDouble(),
          'ratingId': response.data['rating_id'], // Assuming the API returns rating_id
        };
      } else if (response.statusCode == 404) {
        return {
          'rating': 0.0, // Indiquer qu'aucune note n'a été trouvée
          'ratingId': null,
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load rating',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.message}');
        print('DioException type: ${e.type}');
        print('DioException response: ${e.response?.data}');
        rethrow;
      } else {
        print('Unexpected error: $e');
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<void> submitRating(int tournamentId, int userId, double rating) async {
    final token = await _cacheService.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/ratings",
        data: {
          'tournament_id': tournamentId,
          'user_id': userId,
          'rating': rating,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null && status < 500; // Accepter les codes de statut < 500
          },
        ),
      );
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.message}');
        print('DioException type: ${e.type}');
        print('DioException response: ${e.response?.data}');
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<void> updateRating(int tournamentId, int ratingId, int userId, double rating) async {
    final token = await _cacheService.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      await _dio.patch(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/ratings/$ratingId",
        data: {
          'tournament_id': tournamentId,
          'user_id': userId,
          'rating': rating,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null && status < 500; // Accepter les codes de statut < 500
          },
        ),
      );
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.message}');
        print('DioException type: ${e.type}');
        print('DioException response: ${e.response?.data}');
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<Map<String, dynamic>> fetchRatingDetails(int tournamentId, int userId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/rating",
        data: {
          'tournament_id': tournamentId,
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null && status < 500; // Accepter les codes de statut < 500
          },
        ),
      );

      if (response.statusCode == 200) {
        return {
          'rating': (response.data['rating'] as num).toDouble(),
          'ratingId': response.data['id'],
        };
      } else if (response.statusCode == 404) {
        return {
          'rating': 0.0, // Indiquer qu'aucune note n'a été trouvée
          'ratingId': null,
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load rating details',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.message}');
        print('DioException type: ${e.type}');
        print('DioException response: ${e.response?.data}');
        rethrow;
      } else {
        print('Unexpected error: $e');
        throw Exception('Unexpected error occurred');
      }
    }
  }
}
