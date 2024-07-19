import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/team.dart';
import 'package:uresport/core/models/tournament.dart';

import 'cache_service.dart';

abstract class ITournamentService {
  Future<List<Tournament>> fetchTournaments(
      {int? limit, int? page, int? ownerId});
  Future<void> inviteUserToTournament(String tournamentId, String username);
  Future<void> upvoteTournament(int tournamentId, String username);
  Future<bool> hasUpvoted(int tournamentId, int userId);
  Future<void> joinTournament(int tournamentId, int teamId);
  Future<bool> hasJoinedTournament(int tournamentId, String username);
  Future<void> inviteTeamToTournament(
    int tournamentId,
    int teamId,
    String teamName,
  );
  Future<List<Team>> fetchTeams();
  Future<Tournament> fetchTournamentById(int tournamentId);
  Future<void> generateBracket(int tournamentId);
  Future<void> joinTournamentWithTeam(int tournamentId, int teamId);
  Future<void> createTournament(Map<String, dynamic> tournamentData);
  Future<void> leaveTournament(int tournamentId, int teamId);
  Future<void> updateTournament(Tournament tournament);
}

class TournamentService implements ITournamentService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  TournamentService(this._dio);

  @override
  Future<List<Tournament>> fetchTournaments(
      {int? limit, int? page, int? ownerId}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (limit != null) {
        queryParameters['limit'] = limit;
      }
      if (page != null) {
        queryParameters['page'] = page;
      }
      if (ownerId != null) {
        queryParameters['where[owner_id]'] = ownerId;
      }

      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/tournaments/",
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final tournaments = (response.data as List)
            .map((json) => Tournament.fromJson(json))
            .toList();
        return tournaments;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load tournaments',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
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
  Future<void> inviteTeamToTournament(
      int tournamentId, int teamId, String teamName) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/invite",
        data: {'name': teamName},
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

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to invite team to tournament',
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
            return status != null && status < 500;
          },
        ),
      );

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
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<bool> hasUpvoted(int tournamentId, int userId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/upvotes/$userId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to check if upvoted',
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
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
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
            return status != null && status < 500;
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

  @override
  Future<List<Team>> fetchTeams() async {
    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/teams",
      );

      if (response.statusCode == 200) {
        debugPrint('API Response: ${response.data}');

        if (response.data == null) {
          throw Exception('Received null response from API');
        } else if (response.data is! List) {
          throw Exception(
              'Expected a list but got ${response.data.runtimeType}');
        }

        return (response.data as List)
            .map((json) => Team.fromJson(json))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load teams',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('DioException: ${e.message}');
        rethrow;
      } else {
        debugPrint('Exception: ${e.toString()}');
        throw Exception('Unexpected error occurred: ${e.toString()}');
      }
    }
  }

  @override
  Future<Tournament> fetchTournamentById(int tournamentId) async {
    try {
      final response = await _dio
          .get("${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId");

      if (response.statusCode == 200) {
        return Tournament.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load tournament',
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
  Future<void> generateBracket(int tournamentId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/bracket",
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
          error: 'Failed to generate bracket',
          type: DioExceptionType.badResponse,
        );
      }

      return;
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<void> joinTournamentWithTeam(int tournamentId, int teamId) async {
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
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
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
  Future<void> createTournament(Map<String, dynamic> tournamentData) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/", // Ensure the URL ends with a trailing slash
        data: tournamentData,
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

      if (response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create tournament',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('DioException: ${e.message}');
        rethrow;
      } else {
        debugPrint('Exception: ${e.toString()}');
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<void> leaveTournament(int tournamentId, int teamId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.delete(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/team/$teamId/leave",
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

      if (response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to leave the tournament',
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
  Future<void> updateTournament(Tournament tournament) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.patch(
        "${dotenv.env['API_ENDPOINT']}/tournaments/${tournament.id}",
        data: tournament.toJson(),
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
          error: 'Failed to update tournament',
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
