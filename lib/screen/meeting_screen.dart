
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
    meeting.on('connection', null, (ev, context) {
      setState(() {});
    });
    meeting.on('user-left', null, (ev, context) {
      setState(() {});
    });
    meeting.on('ended', null, (ev, context) {
      setState(() {});
    });
    meeting.on('connection-setting-changed', null, (ev, context) {
      setState(() {});
    });
    meeting.on('message', null, (ev, context) {
      setState(() {});
    });
    meeting.on('stream-changed', null, (ev, context) {
      setState(() {});
    });

    setState(() {
      isValidMeeting = false;
    });
  }

  void exitClick() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  Widget renderMeeting() {
    var widgets = <Widget>[
      Expanded(
        child: RTCVideoView(_localRenderer),
      ),
    ];
    if (meeting != null &&
        meeting.connections != null &&
        meeting.connections.length > 0) {
      meeting.connections.forEach((connection) {
        if (connection.renderer != null) {
          widgets.add(RemoteConnection(
            renderer: connection.renderer,
          ));
        }
      });
    }
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

  void onEnd() {
    if (meeting != null) {
      meeting.end();
      goToHome();
    }
  }

  void onLeave() {
    if (meeting != null) {
      meeting.leave();
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
    return meeting != null ? meeting.audioEnabled : false;
  }

  bool isAudioEnabled() {
    return meeting != null ? meeting.audioEnabled : false;
  }

  void _select(PopUpChoice choice) {}

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
      appBar: AppBar(
        title: Text("Meeting"),
        actions: _buildActions(),
        backgroundColor: Colors.blueGrey,
      ),
      body: renderMeeting(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
      ),
    );
  }
}
