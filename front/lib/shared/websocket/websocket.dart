import 'package:flutter/foundation.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void connectWebsocket() {
  final ws = Websocket(dotenv.env['WS_ENDPOINT']!);

  ws.on('pong', (socket, message) {
    if (kDebugMode) {
      print('Pong received: $message');
    }
  });

  ws.emit('ping', 'Hello from client!');
}
