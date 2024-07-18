import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/log.dart';
import 'cache_service.dart';

abstract class ILogService {
  Future<List<Log>> fetchLogs();
}

class LogService implements ILogService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  LogService(this._dio);

  @override
  Future<List<Log>> fetchLogs({String? sort}) async {
    final Map<String, dynamic> queryParameters = {};
    if (sort != null) {
      queryParameters['sort'] = sort;
    }
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');
    try {
      final response = await _dio.get(
        '${dotenv.env['API_ENDPOINT']}/logs/',
        queryParameters: queryParameters,
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
          error: response.data['error'] ?? 'Failed to load logs',
          type: DioExceptionType.badResponse,
        );
      }

      return (response.data as List).map((log) => Log.fromJson(log)).toList();
    } catch (e) {
      debugPrint(e.toString());
      if (e is DioException) {
        rethrow;
      } else {
        throw Exception('Unexpected error occurred');
      }
    }
  }
}
