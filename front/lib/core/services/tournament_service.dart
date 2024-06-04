import 'package:dio/dio.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ITournamentService {
  Future<List<Tournament>> fetchTournaments(int limit, int page);
}

class TournamentService implements ITournamentService {
  final Dio _dio;

  TournamentService(this._dio);

  @override
  Future<List<Tournament>> fetchTournaments(int limit, int page) async {
    final response = await _dio.get(
      "${dotenv.env['API_ENDPOINT']}/tournaments",
      queryParameters: {'limit': limit, 'page': page},
    );
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => Tournament.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load tournaments');
    }
  }
}
