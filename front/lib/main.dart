import 'package:flutter/material.dart';
import 'package:uresport/websocket/websocket.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'app.dart';

void main() async {
  Websocket ws = Websocket("ws://10.0.2.2:8080/ws");
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final dio = Dio();
  final authService = AuthService(dio);

  ws.on('pong', (socket, message) {
    print('Pong received: $message');
  });

  ws.emit('ping', 'Hello from client!');

  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>.value(value: authService),
      ],
      child: MyApp(authService: authService),
    ),
  );
}
