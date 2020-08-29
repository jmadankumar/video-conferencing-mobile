
import 'package:flutter/material.dart';
import 'package:video_conferening_mobile/pojo/meeting_detail.dart';
import 'package:video_conferening_mobile/screen/meeting_screen.dart';
import 'package:video_conferening_mobile/widget/button.dart';

class JoinScreen extends StatefulWidget {
  final String meetingId;
  MeetingDetail meetingDetail;

  JoinScreen({Key key, this.meetingId, @required this.meetingDetail})
      : super(key: key);

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void join() {
    var name = textEditingController.text;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return MeetingScreen(
        meetingId: widget.meetingId,
        name: name,
        meetingDetail: widget.meetingDetail,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Meeting'),
      ),
      body: Center(
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
      ),
    );
  }
}
