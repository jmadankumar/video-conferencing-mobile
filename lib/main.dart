import 'package:flutter/material.dart';
import 'package:video_conferening_mobile/screen/home_screen.dart';
import 'package:video_conferening_mobile/screen/meeting_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meet X',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(
        title: 'Home',
      ),
//      initialRoute: '/',
//      routes: {
//        '/': (context) => HomeScreen(title: 'Home'),
//        '/meeting': (context) => MeetingScreen(),
//      },
    );
  }
}
