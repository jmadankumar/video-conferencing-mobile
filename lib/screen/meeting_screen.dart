import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/get_user_media.dart';
import 'package:flutter_webrtc/media_stream.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:video_conferening_mobile/pojo/meeting_detail.dart';
import 'package:video_conferening_mobile/screen/home_screen.dart';
import 'package:video_conferening_mobile/sdk/meeting.dart';
import 'package:video_conferening_mobile/util/user.util.dart';
import 'package:video_conferening_mobile/widget/actions_button.dart';
import 'package:video_conferening_mobile/widget/control_panel.dart';
import 'package:video_conferening_mobile/widget/remote_connection.dart';
import 'package:video_conferening_mobile/widget/remote_video_page_view.dart';

enum PopUpChoiceEnum { CopyLink, CopyId }

class PopUpChoice {
  PopUpChoiceEnum id;
  String title;

  PopUpChoice(this.id, this.title);
}

class MeetingScreen extends StatefulWidget {
  final String meetingId;
  final String name;
  final MeetingDetail meetingDetail;

  MeetingScreen(
      {Key key,
      @required this.meetingId,
      @required this.name,
      @required this.meetingDetail})
      : super(key: key);

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  bool isValidMeeting = false;
  TextEditingController textEditingController = new TextEditingController();
  Meeting meeting;
  bool isConnectionFailed = false;
  final _localRenderer = new RTCVideoRenderer();
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
  final List<PopUpChoice> choices = [
    PopUpChoice(PopUpChoiceEnum.CopyId, 'Copy Meeting ID'),
    PopUpChoice(PopUpChoiceEnum.CopyLink, 'Copy Meeting Link'),
  ];

  @override
  void initState() {
    super.initState();
    initRenderers();
    start();
  }

  @override
  deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    if (meeting != null) {
      meeting.destroy();
      meeting = null;
    }
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

  void start() async {
    final String userId = await loadUserId();
    MediaStream _localstream = await navigator.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = _localstream;
    _localRenderer.objectFit =
        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
    meeting = new Meeting(
      meetingId: widget.meetingDetail.id,
      stream: _localstream,
      userId: userId,
      name: widget.name,
    );
    meeting.on('open', null, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meeting.on('connection', null, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meeting.on('user-left', null, (ev, ctx) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meeting.on('ended', null, (ev, ctx) {
      meetingEndedEvent();
    });
    meeting.on('connection-setting-changed', null, (ev, ctx) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meeting.on('message', null, (ev, ctx) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meeting.on('stream-changed', null, (ev, ctx) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meeting.on('failed', null, (ev, ctx) {
      final snackBar = SnackBar(content: Text('Connection Failed'));
      scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        isConnectionFailed = true;
      });
    });
    meeting.on('not-found', null, (ev, ctx) {
      meetingEndedEvent();
    });
    setState(() {
      isValidMeeting = false;
    });
  }

  void meetingEndedEvent() {
    final snackBar = SnackBar(content: Text('Meeing Ended'));
    scaffoldKey.currentState.showSnackBar(snackBar);
    goToHome();
  }

  void exitClick() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  void onEnd() {
    if (meeting != null) {
      meeting.end();
      meeting = null;
      goToHome();
    }
  }

  void onLeave() {
    if (meeting != null) {
      meeting.leave();
      meeting = null;
      goToHome();
    }
  }

  void onVideoToggle() {
    if (meeting != null) {
      setState(() {
        meeting.toggleVideo();
      });
    }
  }

  void onAudioToggle() {
    if (meeting != null) {
      setState(() {
        meeting.toggleAudio();
      });
    }
  }

  bool isHost() {
    return meeting != null && widget.meetingDetail != null
        ? meeting.userId == widget.meetingDetail.hostId
        : false;
  }

  bool isVideoEnabled() {
    return meeting != null ? meeting.videoEnabled : false;
  }

  bool isAudioEnabled() {
    return meeting != null ? meeting.audioEnabled : false;
  }

  void _select(PopUpChoice choice) {
    final meetingId = widget.meetingId;
    final snackBar = SnackBar(content: Text('Copied'));
    String text = '';
    if (choice.id == PopUpChoiceEnum.CopyId) {
      text = meetingId;
    } else if (choice.id == PopUpChoiceEnum.CopyLink) {
      text = 'https://meetx.madankumar.me/meeting/$meetingId';
    }
    ClipboardManager.copyToClipBoard(text).then((result) {
      scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  void handleReconnect() {
    if (meeting != null) {
      meeting.reconnect();
    }
  }

  List<Widget> _buildActions() {
    var widgets = <Widget>[
      ActionButton(
        text: 'Leave',
        onPressed: onLeave,
        color: Colors.blue,
      ),
    ];
    if (isHost()) {
      widgets.add(
        ActionButton(
          text: 'End',
          onPressed: onEnd,
          color: Colors.red,
        ),
      );
    }
    widgets.add(PopupMenuButton<PopUpChoice>(
      onSelected: _select,
      itemBuilder: (BuildContext context) {
        return choices.map((PopUpChoice choice) {
          return PopupMenuItem<PopUpChoice>(
            value: choice,
            child: Text(choice.title),
          );
        }).toList();
      },
    ));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Meeting"),
        actions: _buildActions(),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: <Widget>[
          meeting != null
              ? RemoteVideoPageView(
                  connections: meeting.connections,
                )
              : Icon(Icons.text_rotation_none),
          Positioned(
            bottom: 60.0,
            right: 0.0,
            child: Container(
              width: 150.0,
              height: 200.0,
              child: RTCVideoView(_localRenderer),
            ),
          )
        ],
      ),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect,
      ),
    );
  }
}
