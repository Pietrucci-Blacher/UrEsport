import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/tournament.dart';

import 'cache_service.dart';

abstract class ITournamentService {
  Future<List<Tournament>> fetchTournaments({int? limit, int? page});
  Future<void> inviteUserToTournament(String tournamentId, String username);
  Future<void> upvoteTournament(int tournamentId, String username);
  Future<bool> hasUpvoted(int tournamentId, String username);
  Future<void> joinTournament(int tournamentId, int teamId);
  Future<bool> hasJoinedTournament(int tournamentId, String username);
}

class TournamentService implements ITournamentService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  TournamentService(this._dio);

  @override
  Future<List<Tournament>> fetchTournaments({int? limit, int? page}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (limit != null) {
        queryParameters['limit'] = limit;
      }
      if (page != null) {
        queryParameters['page'] = page;
      }

      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/tournaments",
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Tournament.fromJson(json))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load tournaments',
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
  Future<void> inviteUserToTournament(
      String tournamentId, String username) async {
    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/invite",
        data: {'username': username},
        options: Options(
            headers: {'Content-Type': 'application/json; charset=UTF-8'}),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to invite user to tournament',
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
  Future<void> upvoteTournament(int tournamentId, String username) async {
    try {
      final token = await _cacheService.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/upvote",
        data: {'username': username},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null &&
                status < 500; // Accepter les codes de statut < 500
          },
        ),
      );

      if (kDebugMode) {
        print('Upvote response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Upvote response data: ${response.data}');
      }

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to upvote tournament. Status code: ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (kDebugMode) {
          print('DioException: ${e.message}');
        }
        if (kDebugMode) {
          print('DioException type: ${e.type}');
        }
        if (kDebugMode) {
          print('DioException response: ${e.response?.data}');
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

  @override
  Future<bool> hasUpvoted(int tournamentId, String username) async {
    try {
      final token = await _cacheService.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/upvoted",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null &&
                status < 500; // Accepter les codes de statut < 500
          },
        ),
      );

      if (kDebugMode) {
        print('Has upvoted response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Has upvoted response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        return response.data['upvoted'] as bool;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to check if upvoted. Status code: ${response.statusCode}',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException) {
        if (kDebugMode) {
          print('DioException: ${e.message}');
        }
        if (kDebugMode) {
          print('DioException type: ${e.type}');
        }
        if (kDebugMode) {
          print('DioException response: ${e.response?.data}');
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

  @override
  Future<void> joinTournament(int tournamentId, int teamId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    final url =
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/team/$teamId/join";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null &&
                status < 500; // Accepter les codes de statut < 500
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Requête réussie
      } else if (response.statusCode == 401) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Unauthorized',
          type: DioExceptionType.badResponse,
        );
      } else if (response.statusCode == 404) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Tournament not found',
          type: DioExceptionType.badResponse,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to join tournament',
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
  Future<bool> hasJoinedTournament(int tournamentId, String username) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    final url =
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/joined/$username";

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          validateStatus: (status) {
            return status != null &&
                status < 500; // Accepter les codes de statut < 500
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['joined'] as bool;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to check if joined tournament',
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
