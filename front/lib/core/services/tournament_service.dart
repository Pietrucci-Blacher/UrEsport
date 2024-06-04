import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/tournament.dart';

abstract class ITournamentService {
  Future<List<Tournament>> fetchTournaments({required int limit, required int page});
  Future<void> inviteUserToTournament(String tournamentId, String username);
}

class TournamentService implements ITournamentService {
  final Dio _dio;

  TournamentService(this._dio);

  @override
  Future<List<Tournament>> fetchTournaments({required int limit, required int page}) async {
    try {
      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/tournaments",
        queryParameters: {'limit': limit, 'page': page},
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Tournament.fromJson(json))
            .toList();
      } else {
        throw DioError(
          response: response,
          error: 'Failed to load tournaments',
          type: DioErrorType.response,
        );
      }
    } catch (e) {
      if (e is DioError) {
        print('Dio error: ${e.message}');
        rethrow;
      } else {
        print('Unexpected error: $e');
        throw Exception('Unexpected error occurred');
      }
    }
  }

  @override
  Future<void> inviteUserToTournament(String tournamentId, String username) async {
    try {
      final response = await _dio.post(
        "${dotenv.env['API_ENDPOINT']}/tournaments/$tournamentId/invite",
        data: {'username': username},
        options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8'}),
      );

      if (response.statusCode != 200) {
        throw DioError(
          response: response,
          error: 'Failed to invite user to tournament',
          type: DioErrorType.response,
        );
      }
    } catch (e) {
      if (e is DioError) {
        print('Dio error: ${e.message}');
        rethrow;
      } else {
        print('Unexpected error: $e');
        throw Exception('Unexpected error occurred');
      }
    }
  }
}
