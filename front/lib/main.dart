import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/shared/websocket/websocket.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final dio = Dio();
  final authService = AuthService(dio);

  connectWebsocket();

  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>.value(value: authService),
      ],
      child: MyApp(authService: authService),
    ),
  );
}
