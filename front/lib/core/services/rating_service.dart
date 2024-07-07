import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/cache_service.dart';

abstract class IRatingService {
  Future<double> getRating(int tournamentId, int userId);
  Future<void> submitRating(int tournamentId, int userId, double rating);
}

class RatingService implements IRatingService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  RatingService(this._dio);

  @override
  Future<double> getRating(int tournamentId, int userId) async {
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
        return (response.data['rating'] as num).toDouble();
      } else if (response.statusCode == 404) {
        return 0.0; // Indiquer qu'aucune note n'a été trouvée
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
}
