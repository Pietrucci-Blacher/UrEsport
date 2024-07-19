import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'cache_service.dart';

abstract class IFeatureFlippingService {
  Future<bool> isFeatureActive(int featureId);
  Future<void> toggleFeature(int featureId);
}

class FeatureFlippingService implements IFeatureFlippingService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

  FeatureFlippingService(this._dio);

  @override
  Future<bool> isFeatureActive(int featureId) async {
    final response = await _dio.get(
      '${dotenv.env['API_ENDPOINT']}/features/$featureId',
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to fetch feature flipping');
    }

    return response.data['active'];
  }

  @override
  Future<void> toggleFeature(int featureId) async {
    final token = await _cacheService.getString('token');
    if (token == null) throw Exception('No token found');

    final response = await _dio.post(
      '${dotenv.env['API_ENDPOINT']}/features/$featureId/toggle',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to toggle feature');
    }
    
    return;
  }
}
