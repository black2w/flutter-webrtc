import 'package:flutter_webrtc/flutter_webrtc.dart';

class Mywebrtcclient {
  Mywebrtcclient(this.onStreamAddOrRemoveEvent);
  final void Function(bool) onStreamAddOrRemoveEvent;


  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;

  Future<void> defaultSetting() async {
    await _initializeRenderers();
    await _getUserMedia();
    await _createPeerConnection();
  }

  Future<void> _initializeRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
}




  Future<void> _getUserMedia() async {
    final mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    localRenderer.srcObject = stream;
    _localStream = stream;

  }

  Future<void> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {


    };

    _peerConnection!.onAddStream = (MediaStream stream) {
      remoteRenderer.srcObject = stream;
      print("onAddStream");
      onStreamAddOrRemoveEvent(true);
    };

    _peerConnection!.onAddTrack = (stream, track) {
      remoteRenderer.srcObject = stream;
      print("onAddTrack");
      onStreamAddOrRemoveEvent(true);
    };

    _peerConnection!.onRemoveStream = (MediaStream stream) {
      print("onRemoveStream");
      onStreamAddOrRemoveEvent(false);
    };

    _peerConnection!.onRemoveTrack = (stream, track) {
      print("onRemoveTrack");
      onStreamAddOrRemoveEvent(false);
    };





    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
  }

  void disconnect() async {
    try {
      await _peerConnection?.close();
      _peerConnection = null;

      // Dispose local stream
      _localStream?.getTracks().forEach((track) {
        track.stop();
      });
      _localStream = null;


      // Clear renderers
      localRenderer.srcObject = null;
      remoteRenderer.srcObject = null;

      // await _localStream?.dispose();
      // await _peerConnection?.close();
      // _peerConnection = null;
      //
      // localRenderer.srcObject = null;
      // remoteRenderer.srcObject = null;
      //
      // dispose();
    } catch (e) {
      print(e.toString());
    }
  }


  Future<RTCSessionDescription?> createOffer() async {
    RTCSessionDescription description = await _peerConnection!.createOffer({
      'offerToReceiveAudio': 1,
      'offerToReceiveVideo': 1,
    });
    await _peerConnection!.setLocalDescription(description);

    return description;
  }

  Future<RTCSessionDescription> handleOffer(dynamic data) async {
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(data['sdp'], data['type']),
    );
    RTCSessionDescription description = await _peerConnection!.createAnswer({
      'offerToReceiveAudio': 1,
      'offerToReceiveVideo': 1,
    });
    await _peerConnection!.setLocalDescription(description);
    return description;
  }

  Future<void> handleAnswer(dynamic data) async {
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(data['sdp'], data['type']),
    );
  }

  Future<void> handleAnswer2(String sdp) async {
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(sdp, 'answer'),
    );
  }

  Future<void> handleCandidate(dynamic data) async {
    RTCIceCandidate candidate = RTCIceCandidate(
      data['candidate'],
      data['sdpMid'],
      data['sdpMLineIndex'],
    );
    await _peerConnection!.addCandidate(candidate);
  }


  //投屏相关
  Future<void> makePush(DesktopCapturerSource? source) async {

  }

}