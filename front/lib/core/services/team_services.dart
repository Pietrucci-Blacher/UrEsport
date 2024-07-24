import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/team.dart';

import 'cache_service.dart';

abstract class ITeamService {
  ValueNotifier<List<Team>> get teamsNotifier;
  Future<List<Team>> getUserTeams(int current);
  Future<Team> createTeam(Map<String, dynamic> teamData);
  Future<void> leaveTeam(int userId, int teamId);
  Future<void> deleteTeam(int teamId);
  Future<void> kickUserFromTeam(int teamId, String username);
  Future<void> inviteUserToTeam(int teamId, String username);
}

class TeamService implements ITeamService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;
  final ValueNotifier<List<Team>> _teamsNotifier =
      ValueNotifier<List<Team>>([]);

  TeamService(this._dio);

  @override
  ValueNotifier<List<Team>> get teamsNotifier => _teamsNotifier;

  @override
  Future<List<Team>> getUserTeams(int userId) async {
    try {
      final response =
          await _dio.get('${dotenv.env['API_ENDPOINT']}/teams/user/$userId');
      if (response.statusCode == 200) {
        final data = response.data as List;
        final teams = data.map((json) => Team.fromJson(json)).toList();

        teams.sort((a, b) => a.name.compareTo(b.name));

        _teamsNotifier.value = teams;
        return teams;
      } else {
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      debugPrint('Error fetching teams: $e');
      throw Exception('Failed to load teams');
    }
  }

  @override
  Future<Team> createTeam(Map<String, dynamic> teamData) async {
    final token = await _cacheService.getString('token');
    try {
      final response = await _dio.post(
        '${dotenv.env['API_ENDPOINT']}/teams/',
        data: teamData,
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
      if (response.statusCode == 201) {
        final newTeam = Team.fromJson(response.data);
        _teamsNotifier.value = [..._teamsNotifier.value, newTeam];
        return newTeam;
      } else {
        final errorMessage =
            response.data['error'] ?? 'Failed to create the team';
        throw DioException(
          requestOptions: response.requestOptions,
          response: Response(
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            data: {'error': errorMessage},
          ),
        );
      }
    } catch (e) {
      debugPrint('Error creating team: $e');
      throw Exception('Failed to create the team');
    }
  }

  @override
  Future<void> leaveTeam(int userId, int teamId) async {
    final token = await _cacheService.getString('token');
    try {
      final response = await _dio.delete(
        '${dotenv.env['API_ENDPOINT']}/teams/$teamId/leave',
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
        final errorMessage =
            response.data['error'] ?? 'Failed to leave the team';
        throw DioException(
          requestOptions: response.requestOptions,
          response: Response(
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            data: {'error': errorMessage},
          ),
        );
      }
    } catch (e) {
      debugPrint('Error leaving team: $e');
      throw Exception('Failed to leave the team');
    }
  }

  @override
  Future<void> deleteTeam(int teamId) async {
    final token = await _cacheService.getString('token');
    try {
      final response = await _dio.delete(
        '${dotenv.env['API_ENDPOINT']}/teams/$teamId',
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
        final errorMessage =
            response.data['error'] ?? 'Failed to delete the team';
        throw DioException(
          requestOptions: response.requestOptions,
          response: Response(
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            data: {'error': errorMessage},
          ),
        );
      }
    } catch (e) {
      debugPrint('Error deleting team: $e');
      throw Exception('Failed to delete the team');
    }
  }

  @override
  Future<void> kickUserFromTeam(int teamId, String username) async {
    final token = await _cacheService.getString('token');
    try {
      final response = await _dio.delete(
        '${dotenv.env['API_ENDPOINT']}/teams/$teamId/kick',
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
      if (response.statusCode != 204) {
        final errorMessage =
            response.data['error'] ?? 'Failed to kick the user';
        throw DioException(
          requestOptions: response.requestOptions,
          response: Response(
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            data: {'error': errorMessage},
          ),
        );
      }
    } catch (e) {
      debugPrint('Error kicking user: $e');
      throw Exception('Failed to kick the user');
    }
  }

  @override
  Future<void> inviteUserToTeam(int teamId, String username) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/teams/$teamId/invite",
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
          error: 'Failed to invite user to team',
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
