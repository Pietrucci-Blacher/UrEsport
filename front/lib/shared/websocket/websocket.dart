import 'package:flutter/foundation.dart';
import 'package:uresport/core/websocket/websocket.dart';

void connectWebsocket() {
  final ws = Websocket.getInstance();

  ws.on('connected', connected);
  ws.on('error', error);
}

void connected(socket, message) {
  debugPrint('connected to websocket');
}

void error(socket, message) {

  debugPrint('Error: $message');

}
