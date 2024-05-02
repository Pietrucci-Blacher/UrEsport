import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/login_request.dart';
import 'package:uresport/core/models/register_request.dart';

abstract class IAuthService {
  Future<void> register(RegisterRequest registerRequest);
  Future<String> login(LoginRequest loginRequest);
  Future<bool> isLoggedIn();
  Future<void> logout();
}

class AuthService implements IAuthService {
  final Dio _dio;

  AuthService(this._dio);

  @override
  Future<void> register(RegisterRequest registerRequest) async {
    if (registerRequest.firstName.isEmpty ||
        registerRequest.lastName.isEmpty ||
        registerRequest.userName.isEmpty ||
        registerRequest.email.isEmpty ||
        registerRequest.password.isEmpty) {
      throw ArgumentError('All fields are required');
    }
    try {
      await _dio.post('${dotenv.env['API_ENDPOINT']}/auth/register', data: {
        'firstname': registerRequest.firstName,
        'lastname': registerRequest.lastName,
        'username': registerRequest.userName,
        'email': registerRequest.email,
        'password': registerRequest.password,
      });
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<String> login(LoginRequest loginRequest) async {
    if (loginRequest.email.isEmpty || loginRequest.password.isEmpty) {
      throw ArgumentError('Email and password are required');
    }

    try {
      final response = await _dio.post('${dotenv.env['API_ENDPOINT']}/auth/login', data: loginRequest.toJson());
      return response.data['token'];
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final response = await _dio.get(Uri.parse('${dotenv.env['API_ENDPOINT']}/users/me').toString());
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = response.data;
        return userData.containsKey('user');
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('${dotenv.env['API_ENDPOINT']}/auth/logout');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
