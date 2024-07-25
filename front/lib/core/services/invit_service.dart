import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/invit.dart';

import 'cache_service.dart';

abstract class IInvitService {
  Future<List<Invit>> fetchInvitations(String where, String inout);
  Future<void> updateTournamentInvitation(
      int tournamentId, int teamId, String status);
  Future<void> updateTeamInvitation(int teamId, String status);
}

class InvitService implements IInvitService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  InvitService(this._dio);

  @override
  Future<List<Invit>> fetchInvitations(String where, String inout) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/invit/$where/$inout",
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
          error: response.data['error'] ?? 'Failed to fetch invitations',
          type: DioExceptionType.badResponse,
        );
      }

      return (response.data as List)
          .map((json) => Invit.fromJson(json))
          .toList();
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
  Future<void> updateTournamentInvitation(
      int tournamentId, int teamId, String status) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/team/$teamId/$status",
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
          error: response.data['error'] ?? 'Failed to update invitation',
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
  Future<void> updateTeamInvitation(int teamId, String status) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/teams/$teamId/$status",
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
          error: response.data['error'] ?? 'Failed to update invitation',
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
}
