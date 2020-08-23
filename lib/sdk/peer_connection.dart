import 'package:eventify/eventify.dart';
import 'package:flutter_webrtc/rtc_peerconnection.dart';
import 'package:flutter_webrtc/rtc_peerconnection_factory.dart';
import 'package:flutter_webrtc/webrtc.dart';

class PeerConnection extends EventEmitter {
  MediaStream localStream;
  MediaStream remoteStream;
  RTCPeerConnection rtcPeerConnection;

  PeerConnection({this.localStream});

  final Map<String, dynamic> configuration = {
    'iceServers': [
      {
        "urls": [
          'stun:stun.l.google.com:19302',
          'stun:stun1.l.google.com:19302'
        ],
      }
    ]
  };
  final Map<String, dynamic> loopbackConstraints = {
    "mandatory": {},
    "optional": [
      {"DtlsSrtpKeyAgreement": false},
    ],
  };

  final Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };

  void start() async {
    rtcPeerConnection =
        await createPeerConnection(configuration, loopbackConstraints);
    rtcPeerConnection.addStream(localStream);
    rtcPeerConnection.onAddStream = _onAddStream;
    rtcPeerConnection.onRemoveStream = _onRemoveStream;
    rtcPeerConnection.onRenegotiationNeeded = _onRenegotiationNeeded;
    rtcPeerConnection.onIceCandidate = _onIceCandidate;
    this.emit('connected');
  }

  void _onAddStream(MediaStream stream) {
    remoteStream = stream;
  }

  void _onRemoveStream(MediaStream stream) {
    remoteStream = null;
  }

  void _onRenegotiationNeeded() {
    print('negotiationneeded');
    this.emit('negotiationneeded');
  }

  void _onIceCandidate(RTCIceCandidate candidate) {
    if (candidate != null) {
      this.emit('candidate', null, candidate);
    }
  }

  Future<RTCSessionDescription> createOffer() async {
    if (rtcPeerConnection != null) {
      final RTCSessionDescription sdp =
          await rtcPeerConnection.createOffer(offerSdpConstraints);
      rtcPeerConnection.setLocalDescription(sdp);
    }
    return null;
  }

  Future<void> setOfferSdp(dynamic sdp) async {
    if (rtcPeerConnection != null) {
      await rtcPeerConnection.setRemoteDescription(sdp);
    }
  }

  Future<RTCSessionDescription> createAnswer() async {
    if (rtcPeerConnection != null) {
      final RTCSessionDescription sdp =
          await rtcPeerConnection.createAnswer(offerSdpConstraints);
      rtcPeerConnection.setLocalDescription(sdp);
    }
    return null;
  }

  Future<void> setAnswerSdp(dynamic sdp) async {
    if (rtcPeerConnection != null) {
      await rtcPeerConnection.setRemoteDescription(sdp);
    }
  }

  Future<void> setCandidate(dynamic candidate) async {
    if (rtcPeerConnection != null) {
      await rtcPeerConnection.addCandidate(candidate);
    }
  }

  void close() {
    if (rtcPeerConnection != null) {
      rtcPeerConnection.close();
      rtcPeerConnection = null;
    }
    localStream = null;
    remoteStream = null;
  }
}
