import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class StreamPeriodicPage extends StatefulWidget {
  const StreamPeriodicPage({Key? key}) : super(key: key);

  @override
  State<StreamPeriodicPage> createState() => _StreamPeriodicPageState();
}

class _StreamPeriodicPageState extends State<StreamPeriodicPage> {
  final Stream _myStream = Stream.periodic(const Duration(seconds: 1), (int count) {
    return count;
  });

  // The subscription on events from _myStream
  late StreamSubscription _sub;

  // This number will be displayed in the center of the screen
  // It changes over time
  int _computationCount = 0;

  // Background color
  // In the beginning, it's indigo but it will be a random color later
  Color _bgColor = Colors.indigo;

  @override
  void initState() {
    _sub = _myStream.listen((event) {
      setState(() {
        _computationCount = event;

        // Set the background color to a random color
        _bgColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: Stack(
        children: [
          Center(
            child: Text(
              _computationCount.toString(),
              style: const TextStyle(fontSize: 150, color: Colors.white),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              tooltip: 'Stop',
              child: const Icon(
                Icons.stop,
                size: 30,
              ),
              onPressed: () => _sub.cancel(),
            ),
          ),
        ],
      ),
    );
  }

  // Cancel the stream listener on dispose
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
