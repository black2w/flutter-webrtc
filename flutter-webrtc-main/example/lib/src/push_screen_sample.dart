import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushScreenSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PushScreenSampleState();
  }

}

class _PushScreenSampleState extends State<PushScreenSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the button press event
          print('Button pressed for Cell!');
        },
        child: Icon(Icons.camera_alt_outlined),
      ),
      body: Builder(builder: (context) {
        // final data = _data;
        //
        // if (data == null) {
        //   return Container();
        // }
        // return Center(
        //   child: Image.memory(
        //     data,
        //     fit: BoxFit.contain,
        //     width: double.infinity,
        //     height: double.infinity,
        //   ),
        // );

        return Container();
      }),
    );
  }

}