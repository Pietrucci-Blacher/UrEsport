import 'package:flutter/material.dart';
import 'package:uresport/websocket/websocket.dart';
import 'app.dart';

Future main() async {
  Websocket ws = Websocket("ws://10.0.2.2:8080/ws");

  ws.on('pong', (socket, message) {
    print('Pong received: $message');
  });

  ws.emit('ping', 'Hello from client!');

  runApp(const MyApp());
}
