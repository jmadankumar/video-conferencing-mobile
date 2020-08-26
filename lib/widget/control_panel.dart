import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final bool videoEnabled;
  final bool audioEnabled;

  final VoidCallback onVideoToggle;
  final VoidCallback onAudioToggle;

  ControlPanel({
    this.onAudioToggle,
    this.onVideoToggle,
    this.videoEnabled,
    this.audioEnabled,
  });

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[
      IconButton(
        onPressed: onVideoToggle,
        icon: Icon(videoEnabled ? Icons.videocam : Icons.videocam_off),
        color: Colors.white,
        iconSize: 32.0,
      ),
      IconButton(
        onPressed: onAudioToggle,
        icon: Icon(audioEnabled ? Icons.mic : Icons.mic_off),
        color: Colors.white,
        iconSize: 32.0,
      ),
      IconButton(
        onPressed: onAudioToggle,
        icon: Icon(Icons.chat),
        color: Colors.white,
        iconSize: 32.0,
      ),
      IconButton(
        onPressed: onAudioToggle,
        icon: Icon(Icons.group),
        color: Colors.white,
        iconSize: 32.0,
      ),
    ];
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widgets,
      ),
      color: Colors.blueGrey[700],
      height: 60.0,
    );
  }
}
