import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_example/src/HttpUtils/my_webrtc_client.dart';
import 'package:flutter_webrtc_example/src/widgets/screen_select_dialog.dart';

import 'HttpUtils/ApiService.dart';
import 'HttpUtils/MyWebRTCClient.dart';

class demo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _demoState();
  }

}

class _demoState extends State<demo> {
  final TextEditingController _controller = TextEditingController();
  String _sdp = "";
  bool needShowRenderView = false;
  bool isPush = false;

  final ApiService _apiService = ApiService();

  late MyWebrtcClient _client;

  @override
  void initState() {
    // TODO: implement initState
    _client = MyWebrtcClient(refreshRenderView);
    _client.defaultSetting();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              needShowRenderView ?
              Container(
                decoration: BoxDecoration(color: Colors.black54),
                child: orientation == Orientation.portrait
                    ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: isPush ? RTCVideoView(_client.localRenderer!) : RTCVideoView(_client.remoteRenderer!),
                      )
                    ])
                    : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: isPush ? RTCVideoView(_client.localRenderer!) : RTCVideoView(_client.remoteRenderer!),
                      )
                    ]),
              ) : Container(
                decoration: BoxDecoration(color: Colors.white),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '输入投屏码',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            print('观看 pressed: ${_controller.text}');
                            startPULL();
                          },
                          child: Text('观看'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            print('投屏 pressed: ${_controller.text}');
                            startPUSH(context);
                          },
                          child: Text('投屏'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            print('停止 pressed: ${_controller.text}');
                            stop();
                          },
                          child: Text('停止'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // var widgets = <Widget>[
  //   //   Expanded(
  //   //     child: RTCVideoView(_client.remoteRenderer),
  //   //   )
  //   // ];
  //
  //
  //   if(isPush) {
  //     return Scaffold(
  //       body: OrientationBuilder(
  //         builder: (context, orientation) {
  //           return Stack(
  //             children: [
  //               needShowRenderView ?
  //               Container(
  //                 decoration: BoxDecoration(color: Colors.black54),
  //                 child: orientation == Orientation.portrait
  //                     ? Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Expanded(
  //                         child: RTCVideoView(_client.localRenderer!),
  //                       )
  //                     ])
  //                     : Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Expanded(
  //                         child: RTCVideoView(_client.localRenderer!),
  //                       )
  //                     ]),
  //               ) : Container(
  //                 decoration: BoxDecoration(color: Colors.white),
  //               ),
  //               Align(
  //                 alignment: Alignment.bottomCenter,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: TextField(
  //                         controller: _controller,
  //                         decoration: InputDecoration(
  //                           border: OutlineInputBorder(),
  //                           labelText: '输入投屏码',
  //                         ),
  //                       ),
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             print('观看 pressed: ${_controller.text}');
  //                             startPULL();
  //                           },
  //                           child: Text('观看'),
  //                         ),
  //                         SizedBox(width: 10),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             print('投屏 pressed: ${_controller.text}');
  //                             startPUSH(context);
  //                           },
  //                           child: Text('投屏'),
  //                         ),
  //                         SizedBox(width: 10),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             print('停止 pressed: ${_controller.text}');
  //                             stop();
  //                           },
  //                           child: Text('停止'),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     return Scaffold(
  //       body: OrientationBuilder(
  //         builder: (context, orientation) {
  //           return Stack(
  //             children: [
  //               needShowRenderView ?
  //               Container(
  //                 decoration: BoxDecoration(color: Colors.black54),
  //                 child: orientation == Orientation.portrait
  //                     ? Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Expanded(
  //                         child: RTCVideoView(_client.remoteRenderer!),
  //                       )
  //                     ])
  //                     : Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Expanded(
  //                         child: RTCVideoView(_client.remoteRenderer!),
  //                       )
  //                     ]),
  //               ) : Container(
  //                 decoration: BoxDecoration(color: Colors.white),
  //               ),
  //               Align(
  //                 alignment: Alignment.bottomCenter,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: TextField(
  //                         controller: _controller,
  //                         decoration: InputDecoration(
  //                           border: OutlineInputBorder(),
  //                           labelText: '输入投屏码',
  //                         ),
  //                       ),
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             print('观看 pressed: ${_controller.text}');
  //                             startPULL();
  //                           },
  //                           child: Text('观看'),
  //                         ),
  //                         SizedBox(width: 10),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             print('投屏 pressed: ${_controller.text}');
  //                             startPUSH(context);
  //                           },
  //                           child: Text('投屏'),
  //                         ),
  //                         SizedBox(width: 10),
  //                         ElevatedButton(
  //                           onPressed: () {
  //                             print('停止 pressed: ${_controller.text}');
  //                             stop();
  //                           },
  //                           child: Text('停止'),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     );
  //   }
  // }


   void refreshRenderView(bool state) {
    setState(() {
      needShowRenderView = state;
    });
  }


  Future<void> startPULL() async {
    setState(() {
      isPush = false;
    });
    
    RTCSessionDescription? sdp = await _client.createPullOffer();
    if (sdp != null) {
      print("请求的SDP为${sdp.type!} 内容为：${sdp.sdp!}");

      String? response = await _apiService.pull(_controller.text, sdp!.sdp ?? "");
      if (response != null) {
        print("返回的SDP为${response}}");
        _client.handleAnswer2(response!);
      }
    }
  }


  Future<void>startPUSH(BuildContext context) async {
    setState(() {
      isPush = true;
    });
    
    await selectScreenSourceDialog(context);
  }

  Future<void>stop() async {
    _client.disconnect();
  }


  //push相关
  Future<void> selectScreenSourceDialog(BuildContext context) async {
    if (WebRTC.platformIsDesktop) {
      final source = await showDialog<DesktopCapturerSource>(
        context: context,
        builder: (context) => ScreenSelectDialog(),
      );
      if (source != null) {
        await _client.makePush(source);
      }

      RTCSessionDescription? sdp = await _client.createPUSHOffer();
      if (sdp != null) {
        print("请求的SDP为${sdp.type!} 内容为：${sdp.sdp!}");

        String? response = await _apiService.push(_controller.text, sdp!.sdp ?? "");
        if (response != null) {
          print("返回的SDP为${response}}");
          _client.handleAnswer2(response!);
        }
      }
    }
  }

  //


}