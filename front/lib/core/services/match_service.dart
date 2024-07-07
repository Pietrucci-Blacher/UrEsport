import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/match.dart';

abstract class IMatchService {
  Future<List<Match>> fetchMatches({int? limit, int? page});
}

class MatchService implements IMatchService {
  final Dio _dio;

  MatchService(this._dio);

  @override
  Future<List<Match>> fetchMatches({int? limit, int? page}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (limit != null) {
        queryParameters['limit'] = limit;
      }
      if (page != null) {
        queryParameters['page'] = page;
      }

      final response = await _dio.get(
        "${dotenv.env['API_ENDPOINT']}/matches",
        queryParameters: queryParameters,
      );

      print('status code: ${response.statusCode}');
      print('response: ${response.data}');

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load matches',
          type: DioExceptionType.badResponse,
        );
      }

      print('test');

      final List<Match> test = response.data
          .map((json) => Match.fromJson(json))
          .toList();

      print('test: $test');

      return test;

      // return (response.data as List)
      //     .map((json) => Match.fromJson(json))
      //     .toList();
    } catch (e) {
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }
}
