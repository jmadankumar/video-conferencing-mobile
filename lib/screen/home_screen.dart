import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:video_conferening_mobile/pojo/meeting_detail.dart';
import 'package:video_conferening_mobile/screen/join_screen.dart';
import 'package:video_conferening_mobile/service/meeting_api.dart';
import '../widget/button.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => JoinScreen(
          meetingId: meetingDetail.id,
          meetingDetail: meetingDetail,
        ),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      Response response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetail = MeetingDetail.fromJson(data);
      print('meetingDetail $meetingDetail');
      goToJoinScreen(meetingDetail);
    } catch (err) {
      final snackbar = SnackBar(content: Text('Invalid MeetingId'));
      scaffoldKey.currentState.showSnackBar(snackbar);
      print(err);
    }
  }

  void joinMeetingClick() async {
    final meetingId = controller.text;
    print('Joined meeting $meetingId');
    validateMeeting(meetingId);
   }

  void startMeetingClick() async {
    var response = await startMeeting();
    final body = json.decode(response.body);
    final meetingId = body['meetingId'];
    print('Started meeting $meetingId');
    validateMeeting(meetingId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 40.0),
                child: Text(
                  "Welcome to Meet X",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 32.0,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter the Meeting Id',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Button(
                text: "Join Meeting",
                onPressed: joinMeetingClick,
              ),
              Button(
                text: "Start Meeting",
                onPressed: startMeetingClick,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
