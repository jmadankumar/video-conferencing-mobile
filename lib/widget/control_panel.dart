import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final bool videoEnabled;
  final bool audioEnabled;
  final bool isHost;
  final Function onEnd;
  final VoidCallback onLeave;
  final VoidCallback onVideoToggle;
  final VoidCallback onAudioToggle;

  ControlPanel(
      {this.onEnd,
      this.onLeave,
      this.onAudioToggle,
      this.onVideoToggle,
      this.videoEnabled,
      this.audioEnabled,
      this.isHost});

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[
      IconButton(
        onPressed: onVideoToggle,
        icon: Icon(videoEnabled ? Icons.videocam : Icons.videocam_off),
      ),
      IconButton(
        onPressed: onAudioToggle,
        icon: Icon(audioEnabled ? Icons.mic : Icons.mic_off),
      ),
      RaisedButton(
        onPressed: onLeave,
        child: Text('Leave'),
      ),
    ];
    if (isHost) {
      widgets.add(
        RaisedButton(
          onPressed: onEnd,
          child: Text('End'),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }
}
