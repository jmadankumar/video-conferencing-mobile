import 'package:flutter/material.dart';
import 'package:flutter_webrtc/enums.dart';
import 'package:flutter_webrtc/media_stream.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:video_conferening_mobile/sdk/connection.dart';

class RemoteConnection extends StatefulWidget {
//  final RTCVideoRenderer renderer = new RTCVideoRenderer();
  final RTCVideoRenderer renderer;
  final Connection connection;

//  final MediaStream stream;

//  RemoteConnection({@required this.stream});
  RemoteConnection({@required this.renderer, @required this.connection});

  @override
  _RemoteConnectionState createState() => _RemoteConnectionState();
}

class _RemoteConnectionState extends State<RemoteConnection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          RTCVideoView(widget.renderer),
          Positioned(
            child: Container(
              padding: EdgeInsets.all(5),
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Text(
                widget.connection.name,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            bottom: 10.0,
            left: 10.0,
          ),
          Container(
            color: widget.connection.videoEnabled
                ? Colors.transparent
                : Colors.black,
            child: Center(
                child: Text(
              widget.connection.videoEnabled ? '' : widget.connection.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            )),
          ),
          Positioned(
            child: Container(
              padding: EdgeInsets.all(5),
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Row(
                children: <Widget>[
                  Icon(
                    widget.connection.videoEnabled
                        ? Icons.videocam
                        : Icons.videocam_off,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  Icon(
                    widget.connection.audioEnabled ? Icons.mic : Icons.mic_off,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            bottom: 10.0,
            right: 10.0,
          )
        ],
      ),
    );
  }
}
