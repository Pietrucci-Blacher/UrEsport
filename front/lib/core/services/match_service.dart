import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/match.dart';

abstract class IMatchService {
  Future<List<Match>> fetchMatches({int? limit, int? page, int? tournamentId});
}

class MatchService implements IMatchService {
  final Dio _dio;

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
          error: 'Failed to load matches',
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
}
