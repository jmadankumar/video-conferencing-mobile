import 'package:flutter_webrtc/rtc_ice_candidate.dart';
import 'package:flutter_webrtc/rtc_session_description.dart';
import 'package:video_conferening_mobile/sdk/message_format.dart';

class JoinedMeetingData {
  String userId;
  String name;

  JoinedMeetingData({this.userId, this.name});

  factory JoinedMeetingData.fromJson(dynamic json) {
    return JoinedMeetingData(
      userId: json['userId'],
      name: json['name'],
    );
  }
}

class Config {
  bool videoEnabled;
  bool audioEnabled;

  Config({this.videoEnabled, this.audioEnabled});
}

class UserJoinedData {
  String userId;
  String name;
  Config config;

  UserJoinedData({this.userId, this.name, this.config});

  factory UserJoinedData.fromJson(dynamic json) {
    return UserJoinedData(
      userId: json['userId'],
      name: json['name'],
      config: Config(
        audioEnabled: json['config']['audioEnabled'],
        videoEnabled: json['config']['videoEnabled'],
      ),
    );
  }
}

class IncomingConnectionRequestData {
  String userId;
  String name;
  Config config;

  IncomingConnectionRequestData({this.userId, this.name, this.config});

  factory IncomingConnectionRequestData.fromJson(dynamic json) {
    return IncomingConnectionRequestData(
      userId: json['userId'],
      name: json['name'],
      config: Config(
        audioEnabled: json['config']['audioEnabled'],
        videoEnabled: json['config']['videoEnabled'],
      ),
    );
  }
}

class OfferSdpData {
  String userId;
  String name;
  RTCSessionDescription sdp;

  OfferSdpData({this.userId, this.name, this.sdp});

  factory OfferSdpData.fromJson(dynamic json) {
    return OfferSdpData(
      userId: json['userId'],
      name: json['name'],
      sdp: RTCSessionDescription(json['sdp']['sdp'], json['sdp']['type']),
    );
  }
}

class AnswerSdpData {
  String userId;
  String name;
  RTCSessionDescription sdp;

  AnswerSdpData({this.userId, this.name, this.sdp});

  factory AnswerSdpData.fromJson(dynamic json) {
    return AnswerSdpData(
      userId: json['userId'],
      name: json['name'],
      sdp: RTCSessionDescription(json['sdp']['sdp'], json['sdp']['type']),
    );
  }
}

class MeetingEndedData {
  String userId;
  String name;

  MeetingEndedData({this.userId, this.name});

  factory MeetingEndedData.fromJson(dynamic json) {
    return MeetingEndedData(
      userId: json['userId'],
      name: json['name'],
    );
  }
}

class UserLeftData {
  String userId;
  String name;

  UserLeftData({this.userId, this.name});

  factory UserLeftData.fromJson(dynamic json) {
    return UserLeftData(
      userId: json['userId'],
      name: json['name'],
    );
  }
}

class IceCandidateData {
  String userId;
  String name;
  RTCIceCandidate candidate;

  IceCandidateData({this.userId, this.name, this.candidate});

  factory IceCandidateData.fromJson(dynamic json) {
    return IceCandidateData(
      userId: json['userId'],
      name: json['name'],
      candidate: RTCIceCandidate(
        json['candidate']['candidate'],
        json['candidate']['sdpMid'],
        json['candidate']['sdpMLineIndex'],
      ),
    );
  }
}

class VideoToggleData {
  String userId;
  bool videoEnabled;

  VideoToggleData({this.userId, this.videoEnabled});

  factory VideoToggleData.fromJson(dynamic json) {
    return VideoToggleData(
      userId: json['userId'],
      videoEnabled: json['videoEnabled'],
    );
  }
}

class AudioToggleData {
  String userId;
  bool audioEnabled;

  AudioToggleData({this.userId, this.audioEnabled});

  factory AudioToggleData.fromJson(dynamic json) {
    return AudioToggleData(
      userId: json['userId'],
      audioEnabled: json['audioEnabled'],
    );
  }
}

class MessageData {
  String userId;
  MessageFormat message;

  MessageData({this.userId, this.message});

  factory MessageData.fromJson(dynamic json) {
    return MessageData(
      userId: json['userId'],
      message: MessageFormat(
        userId: json['message']['userId'],
        text: json['message']['text'],
      ),
    );
  }
}
