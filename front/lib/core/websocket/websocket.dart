import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websocket {
  Map<String, Function> listeners = {};
  late WebSocketChannel channel;

  Websocket(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel.stream.listen((message) {
      var data = jsonDecode(message);
      if (listeners.containsKey(data['command'])) {
        listeners[data['command']]!(this, data['message']);
      }
    });
  }

  void on(String event, Function callback) {
    listeners[event] = callback;
  }

  void emit(String event, dynamic message) {
    var data = jsonEncode({'command': event, 'message': message});
    channel.sink.add(data);
  }
}
