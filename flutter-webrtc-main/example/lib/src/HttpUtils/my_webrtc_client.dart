import 'package:flutter_webrtc/flutter_webrtc.dart';

class MyWebrtcClient {
  MyWebrtcClient(this.onStreamAddOrRemoveEvent);
  final void Function(bool) onStreamAddOrRemoveEvent;


  RTCVideoRenderer? localRenderer;
  RTCVideoRenderer? remoteRenderer;
  DesktopCapturerSource? selectSource;

  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;


  Future<void> defaultSetting() async {

  }


  Future<void>  connect(bool isDesktop) async {
    localRenderer = RTCVideoRenderer();
    remoteRenderer = RTCVideoRenderer();

    await localRenderer?.initialize();
    await remoteRenderer?.initialize();

    if (isDesktop) {
      try {
        var stream =  await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
          'video': selectSource == null
              ? true
              : {
            'deviceId': {'exact': selectSource!.id},
            'mandatory': {'frameRate': 30.0}
          },
          'audio': false,
        });

        // 获取音频流
        MediaStream audioStream = await navigator.mediaDevices.getUserMedia({
          'audio': true,
          'video': false,
        });

        audioStream.getAudioTracks().forEach((track) {
          track.enabled = false;
          stream.addTrack(track);
        });

        stream.getVideoTracks()[0].onEnded = () {
          print('By adding a listener on onEnded you can: 1) catch stop video sharing on Web');
        };

        _localStream = stream;
        localRenderer?.srcObject = _localStream;

        onStreamAddOrRemoveEvent(true);
      } catch (e) {
        print(e.toString());
      }

    } else {
      final mediaConstraints = {
        'audio': true,
        'video': {
          'facingMode': 'user',
        },
      };

      MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      localRenderer?.srcObject = stream;
      _localStream = stream;
    }


    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };



    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {


    };

    _peerConnection!.onAddStream = (MediaStream stream) {
      remoteRenderer?.srcObject = stream;
      print("onAddStream");
      onStreamAddOrRemoveEvent(true);
    };

    _peerConnection!.onAddTrack = (stream, track) {
      remoteRenderer?.srcObject = stream;
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

    _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      print("state = ${state}");
    };

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate){
      print("candidate = ${candidate.toMap()}");
    };

    _peerConnection!.onSignalingState = (RTCSignalingState state) {
      print("RTCSignalingState = ${state}");
    };



    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
  }

  void disconnect() async {
    try {
      await _localStream?.dispose();
      await _peerConnection?.close();
      _peerConnection = null;
      localRenderer?.srcObject = null;
      remoteRenderer?.srcObject = null;

      onStreamAddOrRemoveEvent(false);
    } catch (e) {
      print(e.toString());
    }
  }


  Future<RTCSessionDescription?> createPullOffer() async {
   await connect(false);

    RTCSessionDescription description = await _peerConnection!.createOffer({
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

  //拉流相关



  //投屏相关
  Future<RTCSessionDescription?> createPUSHOffer() async {
    await connect(true);

    RTCSessionDescription description = await _peerConnection!.createOffer({
      'offerToReceiveAudio': 1,
      'offerToReceiveVideo': 1,
    });
    await _peerConnection!.setLocalDescription(description);

    return description;
  }


  Future<void> makePush(DesktopCapturerSource? source) async {
    selectSource = source;
    // try {
    //   var stream =  await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
    //     'video': source == null
    //         ? true
    //         : {
    //       'deviceId': {'exact': source!.id},
    //       'mandatory': {'frameRate': 30.0}
    //     }
    //   });
    //   stream.getVideoTracks()[0].onEnded = () {
    //     print('By adding a listener on onEnded you can: 1) catch stop video sharing on Web');
    //   };
    //
    //   _localStream = stream;
    //   localRenderer?.srcObject = _localStream;
    //
    //   onStreamAddOrRemoveEvent(true);
    // } catch (e) {
    //   print(e.toString());
    // }
  }
}