import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IAuthService {
  Future<void> register(String firstName, String lastName, String userName, String email, String password);
  Future<void> login(String email, String password);
}

class AuthService implements IAuthService {
  final Dio _dio;

  AuthService(this._dio);

  @override
  Future<void> register(String firstName, String lastName, String userName, String email, String password) async {
    try {
      await _dio.post('${dotenv.env['API_ENDPOINT']}/auth/register', data: {
        'firstname': firstName,
        'lastname': lastName,
        'username': userName,
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw Exception('Failed to register');
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await _dio.post('${dotenv.env['API_ENDPOINT']}/auth/login', data: {
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw Exception('Failed to login');
    }
  }
}
