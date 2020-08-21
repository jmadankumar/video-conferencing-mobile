import 'package:flutter/material.dart';

class MeetingScreen extends StatefulWidget {
  MeetingScreen({Key key}) : super(key: key);

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meeting"),
      ),
      body: Center(
        child: Text(
          'Meeting Screen',
        ),
      ),
    );
  }
}
