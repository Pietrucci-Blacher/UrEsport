import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IFeatureFlippingService {
  Future<bool> isFeatureActive(String featureName);
}

class FeatureFlippingService implements IFeatureFlippingService {
  final Dio _dio;

  FeatureFlippingService(this._dio);

  @override
  Future<bool> isFeatureActive(String featureName) async {
    final featureValue =
        await _localStorageService.getFeatureValue(featureName);
    return featureValue == 'true';
  }
}
