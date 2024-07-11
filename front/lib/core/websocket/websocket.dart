import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Websocket {
  Map<String, Function> listeners = {};
  late WebSocketChannel channel;
  static Websocket? instance;
  bool logged = false;

  Websocket({String? token}) {
    connect(token: token);
    listen();
  }

  static Websocket getInstance() {
    return Websocket.instance ??= Websocket();
  }

  void setLogged(bool value) {
    logged = value;
  }

  bool isLogged() {
    return logged;
  }

  void connect({String? token}) async {
    String url = dotenv.env['WS_ENDPOINT']!;

    if (token != null) {
      url = '$url?token=$token';
    }

    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void listen() {
    channel.stream.listen((message) {
      var data = jsonDecode(message);
      if (listeners.containsKey(data['command'])) {
        listeners[data['command']]!(this, data['message']);
      }
    });
  }

  void disconnect({rm = false}) {
    channel.sink.close();
    if (rm) {
      Websocket.instance = null;
    }
  }

  void reconnect({String? token}) {
    disconnect();
    connect(token: token);
    listen();
  }

  void on(String command, Function callback) {
    listeners[command] = callback;
  }

  void emit(String command, dynamic message) {
    var data = jsonEncode({'command': command, 'message': message});
    channel.sink.add(data);
  }
}
