import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:kb_ui/constants.dart';

class SocketService {
  static SocketService? _instance;
  IO.Socket? _socket;

  // Private constructor
  SocketService._() {
    _socket = IO.io('http://${ServerConstants.serverUrl}', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket!.onConnect((_) {
      print('Socket connection established');
    });
  }

  static SocketService get instance {
    _instance ??= SocketService._();
    return _instance!;
  }

  void listen(String event, Function handler) {
    print('Listening to $event');
    _socket!.on(
      event,
      (data) => {handler(data)},
    );
  }
}
