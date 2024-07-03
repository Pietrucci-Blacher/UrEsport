import 'package:flutter/foundation.dart';
import 'package:uresport/core/websocket/websocket.dart';

void connectWebsocket() {
  final ws = Websocket.getInstance();

  ws.on('connected', connected);
  ws.on('error', error);
  ws.on('pong', pong);

  ws.emit('ping', 'Hello from client!');
}

void connected(socket, message) {
  if (kDebugMode) {
    print('connected to websocket');
  }
}

void error(socket, message) {
  if (kDebugMode) {
    print('Error: $message');
  }
}

void pong(socket, message) {
  if (kDebugMode) {
    print('Pong received: $message');
  }
}
