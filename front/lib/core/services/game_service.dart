import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/game.dart';
import 'package:flutter/foundation.dart';

abstract class IGameService {
  Future<List<Game>> fetchGames();
}

class GameService implements IGameService {
  final Dio _dio;

  GameService(this._dio);

  @override
  Future<List<Game>> fetchGames() async {
    try {
      final response = await _dio.get("${dotenv.env['API_ENDPOINT']}/games");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data is List) {
          return data.map((json) => Game.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to load games',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (kDebugMode) {
          print('Dio exception: ${e.message}');
        }
        rethrow;
      } else {
        if (kDebugMode) {
          print('Unexpected error: $e');
        }
        throw Exception('Unexpected error occurred');
      }
    }
  }
}
