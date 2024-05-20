import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/websocket/websocket.dart';
import 'app.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  Websocket ws = Websocket(dotenv.get('WS_ENDPOINT'));

  ws.on('pong', (socket, message) {
    print('Pong received: $message');
  });

  ws.emit('ping', 'Hello from client!');

  runApp(const MyApp());
}
