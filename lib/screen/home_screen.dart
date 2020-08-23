import 'package:flutter/material.dart';
import 'package:video_conferening_mobile/screen/meeting_screen.dart';
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
  String meetingId;
  final TextEditingController controller = new TextEditingController();

  void joinMeetingClick() {
    final meetingId = controller.text;
    print('Joined meeting ${meetingId}');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingScreen(
          meetingId: meetingId,
        ),
      ),
    );
  }

  void startMeetingClick() async {
//    Navigator.pushNamed(context, '/meeting');
    var response = await startMeeting();
    final body = json.decode(response.body);
    final meetingId = body['meetingId'];
    print('Started meeting ${meetingId}');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingScreen(
          meetingId: meetingId,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
