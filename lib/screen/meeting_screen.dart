import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/get_user_media.dart';
import 'package:flutter_webrtc/media_stream.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:http/http.dart';
import 'package:video_conferening_mobile/screen/home_screen.dart';
import 'package:video_conferening_mobile/sdk/meeting.dart';
import 'package:video_conferening_mobile/service/meeting_api.dart';
import 'package:video_conferening_mobile/util/user.util.dart';
import 'package:video_conferening_mobile/widget/button.dart';
import 'package:web_socket_channel/io.dart';

class MeetingScreen extends StatefulWidget {
  String meetingId;

  MeetingScreen({Key key, this.meetingId}) : super(key: key);

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  Map<String, dynamic> meetingDetails;
  bool isValidMeeting = false;
  TextEditingController textEditingController = new TextEditingController();
  Meeting meeting;
  final _localRenderer = new RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {
    "audio": true,
    "video": true,
//    {
//      "mandatory": {
//        "minWidth":
//            '1280', // Provide your own width, height and frame rate here
//        "minHeight": '720',
//        "minFrameRate": '30',
//      },
//      "facingMode": "user",
//      "optional": [],
//    }
  };

  @override
  void initState() {
    super.initState();
    initRenderers();
    validateMeeting();
  }

  @override
  deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    meeting.destroy();
    meeting = null;
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  void goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          title: 'Home',
        ),
      ),
    );
  }

  void validateMeeting() async {
    String meetingId = widget.meetingId;
    print('join $meetingId');
    try {
      Response response = await joinMeeting(meetingId);
      meetingDetails = json.decode(response.body);
      print('meetingDetails $meetingDetails');
      if (meetingDetails['message'] != null) {
        goToHome();
      } else {
        setState(() {
          isValidMeeting = true;
        });
      }
    } catch (err) {
      goToHome();
      print(err);
    }
  }

  void join() async {
    final String userId = await loadUserId();
    final String name = textEditingController.text;
    MediaStream _localstream = await navigator.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = _localstream;
    _localRenderer.objectFit =
        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
    meeting = new Meeting(
      meetingId: meetingDetails['id'],
      stream: _localstream,
      userId: userId,
      name: name,
    );
    setState(() {
      isValidMeeting = false;
    });
  }

  void exitClick() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  Widget renderMeeting() {
    if (isValidMeeting) {
      return Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
            ),
            Button(
              text: "Join",
              onPressed: join,
            ),
          ],
        ),
      );
    }
    var widgets = <Widget>[
      Expanded(
        child: RTCVideoView(_localRenderer),
      ),
    ];
    return Container(
      child: Center(
        child: OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widgets,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widgets,
                );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meeting"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: exitClick,
          )
        ],
      ),
      body: renderMeeting(),
    );
  }
}
