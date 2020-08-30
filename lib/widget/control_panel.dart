import 'package:flutter/material.dart';
import 'package:video_conferening_mobile/widget/actions_button.dart';
import 'package:video_conferening_mobile/widget/button.dart';

class ControlPanel extends StatelessWidget {
  final bool videoEnabled;
  final bool audioEnabled;
  final bool isConnectionFailed;
  final bool isChatOpen;
  final VoidCallback onVideoToggle;
  final VoidCallback onAudioToggle;
  final VoidCallback onReconnect;
  final VoidCallback onChatToggle;

  ControlPanel({
    this.onAudioToggle,
    this.onVideoToggle,
    this.videoEnabled,
    this.audioEnabled,
    this.onReconnect,
    this.isConnectionFailed,
    this.onChatToggle,
    this.isChatOpen,
  });

  List<Widget> buildControls() {
    if (!isConnectionFailed) {
      return <Widget>[
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
          onPressed: onChatToggle,
          icon:
              Icon(isChatOpen ? Icons.speaker_notes_off : Icons.speaker_notes),
          color: Colors.white,
          iconSize: 32.0,
        ),
      ];
    } else {
      return <Widget>[
        ActionButton(
          text: 'Reconnect',
          onPressed: onReconnect,
          color: Colors.red,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    var widgets = buildControls();
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
