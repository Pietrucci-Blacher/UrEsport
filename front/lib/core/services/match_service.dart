import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/match.dart';
import 'cache_service.dart';

abstract class IMatchService {
  Future<List<Match>> fetchMatches({int? limit, int? page, int? tournamentId});
  Future<Match> fetchMatch(int matchId);
  Future<Match> updateMatch(int matchId, Map<String, dynamic> data);
  Future<Match> setScore(int matchId, int teamId, int score);
  Future<Match> closeMatch(int matchId, int teamId);
}

class MatchService implements IMatchService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  MatchService(this._dio);

  @override
  Future<List<Match>> fetchMatches(
      {int? limit, int? page, int? tournamentId}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (limit != null) {
        queryParameters['limit'] = limit;
      }
      if (page != null) {
        queryParameters['page'] = page;
      }
      if (tournamentId != null) {
        queryParameters['where[tournament_id]'] = tournamentId;
      }

      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/matches",
        queryParameters: queryParameters,
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to load matches',
          type: DioExceptionType.badResponse,
        );
      }

      return (response.data as List)
          .map((json) => Match.fromJson(json))
          .toList();
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<Match> fetchMatch(int matchId) async {
    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/matches/$matchId",
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to load match',
          type: DioExceptionType.badResponse,
        );
      }

      return Match.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<Match> updateMatch(int matchId, Map<String, dynamic> data) async {
    try {
      final token = await _cacheService.getString('token');
      if (token == null) throw Exception('No token found');
      final response = await _dio.patch(
        "${dotenv.env['API_ENDPOINT']}/matches/$matchId",
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to update match',
          type: DioExceptionType.badResponse,
        );
      }

      return Match.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<Match> setScore(int matchId, int teamId, int score) async {
    try {
      final token = await _cacheService.getString('token');
      if (token == null) throw Exception('No token found');
      final response = await _dio.patch(
        "${dotenv.env['API_ENDPOINT']}/matches/$matchId/team/$teamId/score",
        data: {
          'score': score,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to set score',
          type: DioExceptionType.badResponse,
        );
      }

      return Match.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<Match> closeMatch(int matchId, int teamId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');
    final response = await _dio.patch(
      "${dotenv.env['API_ENDPOINT']}/matches/$matchId/team/$teamId/close",
      options: Options(
        headers: {
          'Authorization' : 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['error'] ?? 'Failed to close match',
        type: DioExceptionType.badResponse,
      );
    }

    return Match.fromJson(response.data);
  }
}
