import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:uresport/core/models/login_request.dart';
import 'package:uresport/core/models/register_request.dart';

abstract class IAuthService {
  Future<void> register(RegisterRequest registerRequest);
  Future<String> login(LoginRequest loginRequest);
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<void> loginWithOAuth(String provider);
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
        // Use the token to authenticate with your backend
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

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: 'YOUR_CALLBACK_URL_SCHEME',
    );

    final token = Uri.parse(result).queryParameters['code'];
    // Use the token to authenticate with your backend
  }

  Future<void> _loginWithDiscord() async {
    final String clientId = dotenv.env['DISCORD_CLIENT_ID']!;
    final String redirectUri = dotenv.env['DISCORD_REDIRECT_URI']!;
    final String url =
        'https://discord.com/api/oauth2/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=identify%20email';

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: 'YOUR_CALLBACK_URL_SCHEME',
    );

    final token = Uri.parse(result).queryParameters['code'];
    // Use the token to authenticate with your backend
  }

  Future<void> _loginWithTwitch() async {
    final String clientId = dotenv.env['TWITCH_CLIENT_ID']!;
    final String redirectUri = dotenv.env['TWITCH_REDIRECT_URI']!;
    final String url =
        'https://id.twitch.tv/oauth2/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=user:read:email';

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: 'YOUR_CALLBACK_URL_SCHEME',
    );

    final token = Uri.parse(result).queryParameters['code'];
    // Use the token to authenticate with your backend
  }
}
