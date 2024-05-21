import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheService {
  CacheService._internal();

  static final CacheService _instance = CacheService._internal();
  static CacheService get instance => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteString(String key) async {
    await _storage.delete(key: key);
  }
}
