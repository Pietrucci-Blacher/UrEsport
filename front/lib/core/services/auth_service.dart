import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:uresport/core/models/login_request.dart';
import 'package:uresport/core/models/register_request.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/core/services/cache_service.dart';

abstract class IAuthService {
  Future<void> register(RegisterRequest registerRequest);
  Future<String> login(LoginRequest loginRequest);
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<void> loginWithOAuth(String provider);
  Future<User> getUser();
  Future<void> verifyCode(String email, String code);
  Future<void> requestPasswordReset(String email);
  Future<void> resetPassword(String code, String newPassword);
  Future<void> setToken(String token);
}

class AuthService implements IAuthService {
  final Dio _dio;
  final CacheService _cacheService = CacheService.instance;

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
      final response = await _dio.post(
        '${dotenv.env['API_ENDPOINT']}/auth/login',
        data: {
          'email': loginRequest.email,
          'password': loginRequest.password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );
      final token = response.data['access_token'];
      await setToken(token);
      return token;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _cacheService.getString('token');
    return token != null;
  }

  @override
  Future<void> logout() async {
    try {
      final token = await _cacheService.getString('token');
      if (token == null) throw Exception('No token found');
      await _cacheService.deleteString('token');

      await _dio.post(
        '${dotenv.env['API_ENDPOINT']}/auth/logout',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return;
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  @override
  Future<void> loginWithOAuth(String provider) async {
    switch (provider) {
      case 'Google':
        await _loginWithGoogle();
        break;
      case 'Apple':
        await _loginWithApple();
        break;
      case 'Discord':
        await _loginWithDiscord();
        break;
      case 'Twitch':
        await _loginWithTwitch();
        break;
      default:
        throw UnimplementedError('Provider $provider not implemented');
    }
  }

  Future<void> _loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;
        final String? token = auth.accessToken;
        // Utiliser le token pour s'authentifier avec votre backend
      }
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<void> _loginWithApple() async {
    final String clientId = dotenv.env['IOS_CLIENT_ID']!;
    final String redirectUri = dotenv.env['IOS_REDIRECT_URI']!;
    final String url =
        'https://appleid.apple.com/auth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=email%20name';

    await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: 'YOUR_CALLBACK_URL_SCHEME',
    );

    // Utiliser le token pour s'authentifier avec votre backend
  }

  Future<void> _loginWithDiscord() async {
    final String clientId = dotenv.env['DISCORD_CLIENT_ID']!;
    final String redirectUri = dotenv.env['DISCORD_REDIRECT_URI']!;
    final String url =
        'https://discord.com/api/oauth2/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=identify%20email';

    await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: 'YOUR_CALLBACK_URL_SCHEME',
    );

    // Utiliser le token pour s'authentifier avec votre backend
  }

  Future<void> _loginWithTwitch() async {
    final String clientId = dotenv.env['TWITCH_CLIENT_ID']!;
    final String redirectUri = dotenv.env['TWITCH_REDIRECT_URI']!;
    final String url =
        'https://id.twitch.tv/oauth2/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=user:read:email';

    await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: 'YOUR_CALLBACK_URL_SCHEME',
    );

    // Utiliser le token pour s'authentifier avec votre backend
  }

  @override
  Future<User> getUser() async {
    try {
      final token = await _cacheService.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await _dio.get(
        '${dotenv.env['API_ENDPOINT']}/users/me',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return User(
          firstName: data['firstName'],
          lastName: data['lastName'],
          username: data['username'],
          email: data['email'],
          avatarUrl: data['avatarUrl'],
        );
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      await logout();
      throw Exception('Failed to load user data: $e');
    }
  }

  @override
  Future<void> verifyCode(String email, String code) async {
    try {
      await _dio.post('${dotenv.env['API_ENDPOINT']}/auth/verify', data: {
        'email': email,
        'code': code,
      });
    } catch (e) {
      throw Exception('Failed to verify code: $e');
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      await _dio.post(
          '${dotenv.env['API_ENDPOINT']}/auth/request-password-reset',
          data: {
            'email': email,
          });
    } catch (e) {
      throw Exception('Failed to request password reset: $e');
    }
  }

  @override
  Future<void> resetPassword(String code, String newPassword) async {
    try {
      await _dio
          .post('${dotenv.env['API_ENDPOINT']}/auth/reset-password', data: {
        'code': code,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<void> setToken(String token) async {
    await CacheService.instance.setString('token', token);
  }
}
