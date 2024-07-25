import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/team.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/cache_service.dart';

abstract class ITournamentService {
  ValueNotifier<List<Tournament>> get tournamentsNotifier;
  Future<List<Tournament>> fetchTournaments(
      {int? limit, int? page, int? ownerId});
  Future<void> inviteUserToTournament(String tournamentId, String username);
  Future<void> upvoteTournament(int tournamentId, String username);
  Future<bool> hasUpvoted(int tournamentId, int userId);
  Future<void> joinTournament(int tournamentId, int teamId);
  Future<bool> hasJoinedTournament(int tournamentId, String username);
  Future<void> inviteTeamToTournament(
      int tournamentId, int teamId, String teamName);
  Future<List<Team>> fetchTeams();
  Future<Tournament> fetchTournamentById(int tournamentId);
  Future<void> generateBracket(int tournamentId);
  Future<void> createTournament(Map<String, dynamic> tournamentData);
  Future<void> leaveTournament(int tournamentId, int teamId);
  Future<void> updateTournament(Tournament tournament);
  Future<String> uploadTournamentImage(int tournamentId, File image);
  Future<List<Team>> getTeamsByTournamentId(int tournamentId);
  Future<void> deleteTournament(int tournamentId);
}

class TournamentService implements ITournamentService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;
  final ValueNotifier<List<Tournament>> _tournamentsNotifier =
      ValueNotifier([]);

  TournamentService(this._dio);

  @override
  ValueNotifier<List<Tournament>> get tournamentsNotifier =>
      _tournamentsNotifier;

  @override
  Future<List<Tournament>> fetchTournaments(
      {int? limit, int? page, int? ownerId}) async {
    try {
      final Map<String, dynamic> queryParameters = {
        if (limit != null) 'limit': limit,
        if (page != null) 'page': page,
        if (ownerId != null) 'where[owner_id]': ownerId,
      };

      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/tournaments/",
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final tournaments = (response.data as List)
            .map((json) => Tournament.fromJson(json))
            .toList();

        _tournamentsNotifier.value =
            tournaments; // Mise à jour du ValueNotifier
        return tournaments;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to load tournaments',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to load tournaments');
      }
    } catch (e) {
      debugPrint('Error: $e');
      // throw Exception('Unexpected error occurred');
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
          error:
              response.data['error'] ?? 'Failed to invite user to tournament',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to invite user to tournament');
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
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to upvote tournament');
      }
    } catch (e) {
      debugPrint('Error upvoting tournament: $e');
      // throw Exception('Unexpected error occurred');
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
          error: response.data['error'] ?? 'Failed to check upvote status',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to check if upvoted');
      }
    } catch (e) {
      debugPrint('Error checking upvote status: $e');
      // throw Exception('Unexpected error occurred');
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
        ),
      );

      if (response.statusCode == 409) {
        // Lever une exception spécifique pour les conflits
        final errorMessage = response.data['error'] ?? 'Conflict';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: errorMessage,
        );
      }

      if (response.statusCode == 401) {
        final errorMessage =
            response.data['error'] ?? 'Team must contain 5 members';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: errorMessage,
        );
      }

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to join tournament',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to join tournament');
      }
    } catch (e) {
      debugPrint('Error joining tournament: $e');
      if (e is DioException && e.response?.statusCode == 409) {
        rethrow;
      } else if (e is DioException && e.response?.statusCode == 401) {
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
        ),
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data['hasJoined'] != null) {
          return response.data['hasJoined'] as bool;
        } else {
          return false;
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to check if joined',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to check if joined tournament');
      }
    } catch (e) {
      debugPrint('Error checking join status: $e');
      // throw Exception('Unexpected error occurred');
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
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              response.data['error'] ?? 'Failed to invite team to tournament',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error inviting team to tournament: $e');
      // throw Exception('Unexpected error occurred');
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
      final response = await _dio.get("${dotenv.env['API_ENDPOINT']}/teams");

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Team.fromJson(json))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to load teams',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to load teams');
      }
    } catch (e) {
      debugPrint('Error fetching teams: $e');
      // throw Exception('Unexpected error occurred');
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
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
          error: response.data['error'] ?? 'Failed to load tournament',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to load tournament');
      }
    } catch (e) {
      debugPrint('Error fetching tournament by ID: $e');
      // throw Exception('Unexpected error occurred');
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
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to generate bracket',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to generate bracket');
      }
    } catch (e) {
      debugPrint('Error generating bracket: $e');
      // throw Exception('Unexpected error occurred');
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
        "${dotenv.env['API_ENDPOINT']}/tournaments/",
        data: tournamentData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 201) {
        final newTournament = Tournament.fromJson(response.data);
        _tournamentsNotifier.value = [
          ..._tournamentsNotifier.value,
          newTournament
        ];
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to create tournament',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error creating tournament: $e');
      if (e is DioException) {
        rethrow;
      } else {
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
        ),
      );

      if (response.statusCode == 404) {
        final errorMessage = response.data['error'] ?? 'Unknown error';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: errorMessage,
        );
      }

      if (response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to leave tournament',
          type: DioExceptionType.badResponse,
        );
        // throw Exception('Failed to leave the tournament');
      }
    } catch (e) {
      debugPrint('Error leaving tournament: $e');
      // throw Exception('Unexpected error occurred');
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
        ),
      );

      if (response.statusCode == 200) {
        final updatedTournaments = _tournamentsNotifier.value.map((t) {
          return t.id == tournament.id ? Tournament.fromJson(response.data) : t;
        }).toList();

        _tournamentsNotifier.value =
            updatedTournaments; // Mise à jour du ValueNotifier
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to update tournament',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error updating tournament: $e');
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<String> uploadTournamentImage(int tournamentId, File image) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final formData = FormData.fromMap({
        'upload[]': await MultipartFile.fromFile(image.path),
      });

      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/image",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to upload tournament image');
      }

      final imageUrl = response.data['image'];
      if (imageUrl == null) {
        throw Exception('Image URL is null');
      }
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading tournament image: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  @override
  Future<List<Team>> getTeamsByTournamentId(int tournamentId) async {
    try {
      final response = await _dio.get(
        '${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/teams',
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Team.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      debugPrint('Error fetching teams by tournament ID: $e');
      throw Exception('Unexpected error occurred');
    }
  }

  @override
  Future<void> deleteTournament(int tournamentId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.delete(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 204) {
        _tournamentsNotifier.value = _tournamentsNotifier.value
            .where((t) => t.id != tournamentId)
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['error'] ?? 'Failed to delete tournament',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      debugPrint('Error deleting tournament: $e');
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }
}
