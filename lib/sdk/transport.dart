import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:eventify/eventify.dart';
import 'package:web_socket_channel/io.dart';

class Transport extends EventEmitter {
  IOWebSocketChannel channel;
  String url;
  bool canReconnect = false;
  int retryCount = 0;
  int maxRetryCount = 1;
  Timer timer;
  bool closed = false;

  Transport({this.url, this.canReconnect, this.maxRetryCount});

  void connect() async {
    try {
      if (retryCount <= maxRetryCount) {
        retryCount++;
        //https://github.com/dart-lang/web_socket_channel/issues/61#issuecomment-585564273
        var ws = await WebSocket.connect(url).timeout(Duration(seconds: 5));
        channel = IOWebSocketChannel(ws);
        listenEvents();
      } else {
        this.emit('failed');
      }
    } catch (error) {
      print(error);
      connect();
    }
  }

  void listenEvents() {
    if (channel != null) {
      channel.stream.listen(handleMessage,
          onDone: handleClose, onError: handleError, cancelOnError: true);
      handleOpen();
    }
  }

  void remoteEvents() {}

  void handleOpen() {
    sendHeartbeat();
    this.emit('open');
  }

  void handleMessage(dynamic message) {
    this.emit('message', null, message);
  }

  void handleClose() {
    reset();
    if (!closed) {
      connect();
    }
  }

  void handleError(Object error) {
    print(error);
    reset();
    if (!closed) {
      connect();
    }
  }

  void send(String message) {
    if (channel != null) {
      channel.sink.add(message);
    }
  }

  void sendHeartbeat() {
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      send(json.encode({'type': 'heartbeat'}));
    });
  }

  void reset() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    if (channel != null) {
      channel.sink.close();
      channel = null;
    }
  }

  void close() {
    closed = true;
    destroy();
  }

  void destroy() {
    reset();
    url = '';
  }

  void reconnect() {
    retryCount = 0;
    connect();
  }
}
