import 'package:eventify/eventify.dart';
import 'package:web_socket_channel/io.dart';

class Transport extends EventEmitter {
  IOWebSocketChannel channel;
  String url;
  bool reconnect = false;
  int retryCount = 0;
  int maxRetryCount = 1;

  Transport({this.url, this.reconnect, this.maxRetryCount});

  void connect() {
    try {
      if (retryCount <= maxRetryCount) {
        retryCount++;
        channel = IOWebSocketChannel.connect(url);
        listenEvents();
      }
    } catch (error) {
      print(error);
      connect();
    }
  }

  void listenEvents() {
    if (channel != null) {
      handleOpen();
      channel.stream
          .listen(handleMessage, onDone: handleClose, onError: handleError);
    }
  }

  void remoteEvents() {}

  void handleOpen() {
    this.emit('open');
  }

  void handleMessage(dynamic message) {
    this.emit('message', null, message);
  }

  void handleClose() {
    this.emit('close');
  }

  void handleError(Object error) {
//    remoteEvents();
    print(error);
    destroy();
    connect();
  }

  void send(String message) {
    if (channel != null) {
      channel.sink.add(message);
    }
  }

  void destroy() {
    if (channel != null) {
      channel.sink.close();
      channel = null;
//      remoteEvents();
    }
  }
}
