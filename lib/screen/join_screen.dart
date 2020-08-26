import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:video_conferening_mobile/pojo/meeting_detail.dart';
import 'package:video_conferening_mobile/screen/home_screen.dart';
import 'package:video_conferening_mobile/screen/meeting_screen.dart';
import 'package:video_conferening_mobile/service/meeting_api.dart';
import 'package:video_conferening_mobile/widget/button.dart';

class JoinScreen extends StatefulWidget {
  final String meetingId;

  JoinScreen({Key key, this.meetingId}) : super(key: key);

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController textEditingController =
      new TextEditingController();
  MeetingDetail meetingDetail;

  @override
  void initState() {
    super.initState();
    validateMeeting();
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
      var data = json.decode(response.body);
      meetingDetail = MeetingDetail.fromJson(data);
      print('meetingDetail $meetingDetail');
    } catch (err) {
      goToHome();
      print(err);
    }
  }

  void join() {
    var name = textEditingController.text;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return MeetingScreen(
        meetingId: widget.meetingId,
        name: name,
        meetingDetail: meetingDetail,
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
