import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyEventChannel extends StatefulWidget {
  @override
  _MyEventChannelState createState() => _MyEventChannelState();
}

class _MyEventChannelState extends State<MyEventChannel> {
  static const EventChannel _eventChannel = EventChannel('com.flutter.guide.EventChannel');
  StreamSubscription? _streamSubscription;
  late Object obj;

  @override
  void initState() {
    super.initState();
    // 监听开始
    _streamSubscription =
        _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('原生交互 - MyEventChannel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$obj'),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("relapse"),
            )
          ],
        ),
      ),
    );
  }

  void _onEvent(Object? event) {
    if (kDebugMode) {
      print('Flutter - 返回的内容: $event');
    }
    if (event != null) {
      setState(() {
        obj = event;
      });
    }
  }

  void _onError(Object error) {
    print('Flutter - 返回错误');
    setState(() {
      obj = error;
    });
  }

  // void deactivate(){
  //   print('deactivate');
  // }

  // void dispose(){
  //   print('dispose');
  // }

}
