import 'package:uresport/core/models/team.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'cache_service.dart';

abstract class ITeamService {
  Future<List<Team>> getUserTeams(int userId);
  Future<void> leaveTeam(int userId, int teamId);
}

class TeamService implements ITeamService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;
  TeamService(this._dio);

  @override
  Future<List<Team>> getUserTeams(int userId) async {
    try {
      final response =
          await _dio.get('${dotenv.env['API_ENDPOINT']}/teams/user/$userId');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => Team.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      debugPrint('Error fetching teams: $e');
      throw Exception('Failed to load teams');
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
}
