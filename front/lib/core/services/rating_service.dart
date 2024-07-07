import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/cache_service.dart';

abstract class IRatingService {
  Future<double> getRating(int tournamentId);
  Future<void> submitRating(int tournamentId, int username, double rating);
}

class RatingService implements IRatingService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  RatingService(this._dio);

  @override
  Future<double> getRating(int tournamentId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/ratings",
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
        return response.data['rating'] as double;
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
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<void> submitRating(int tournamentId, int username, double rating) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/ratings",
        data: {
          'tournament_id': tournamentId,
          'user_id': username,
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

      if (response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to submit rating',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }
}
