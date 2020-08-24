import 'package:flutter/material.dart';
import 'package:flutter_webrtc/enums.dart';
import 'package:flutter_webrtc/media_stream.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:video_conferening_mobile/sdk/connection.dart';

class RemoteConnection extends StatefulWidget {
//  final RTCVideoRenderer renderer = new RTCVideoRenderer();
  final RTCVideoRenderer renderer;
//  final MediaStream stream;

//  RemoteConnection({@required this.stream});
  RemoteConnection({@required this.renderer});

  @override
  _RemoteConnectionState createState() => _RemoteConnectionState();
}

class _RemoteConnectionState extends State<RemoteConnection> {
  @override
  void initState() {
    super.initState();
//    initRenderer();
  }

  void initRenderer() async {
    await widget.renderer.initialize();
    initStream();
  }

  void initStream() async {
    widget.renderer.objectFit =
        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;

//    if (widget.stream != null) {
//      widget.connection.on('stream-changed', null, (ev, context) {
//        if (widget.connection.remoteStream != null) {
//          setState(() {
//            widget.renderer.srcObject = widget.connection.remoteStream;
//            widget.renderer.objectFit =
//                RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
//          });
//        }
//      });
//    }
  }

  @override
  void dispose() {
    super.dispose();
//    widget.renderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    widget.renderer.srcObject = widget.stream;

    return Expanded(
      child: RTCVideoView(widget.renderer),
    );
  }
}
