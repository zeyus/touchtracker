import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const TouchTrackerApp());

/// This is the main application widget.
class TouchTrackerApp extends StatelessWidget {
  const TouchTrackerApp({Key? key}) : super(key: key);

  static const String _title = 'Touch Tracker';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: TouchTrackerWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class TouchTrackerWidget extends StatefulWidget {
  const TouchTrackerWidget({Key? key}) : super(key: key);

  @override
  State<TouchTrackerWidget> createState() => _TouchTrackerWidgetState();
}

/// This is the private State class that goes with TouchTrackerWidget.
class _TouchTrackerWidgetState extends State<TouchTrackerWidget> {
  String _xyStart = '';
  String _xyEnd = '';
  String _xy = '';
  String _vel = '';
  List<List<dynamic>> _logRows = [];
  List<dynamic> _logRow = [];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Text('Start: ' + _xyStart),
          Text('Pos: ' + _xy),
          Text('End: ' + _xyEnd),
          Text('Velocity: ' + _vel)
        ],
      ),
      GestureDetector(onPanStart: (DragStartDetails d) {
        setState(() {
          _xyStart = _xy = d.globalPosition.dx.round().toString() +
              ', ' +
              d.localPosition.dx.round().toString();
        });
      }, onPanUpdate: (DragUpdateDetails d) {
        setState(() {
          _xy = d.globalPosition.dx.round().toString() +
              ', ' +
              d.localPosition.dx.round().toString();
        });
      }, onPanEnd: (DragEndDetails d) {
        setState(() {
          _xyEnd = _xy;
          _vel = d.velocity.toString();
        });
      })
    ]);
  }
}

class ExperimentDataHandler {
  // top level (experiment)
  String subject;

  // trial level
  int trial = 0;
  String _xyStart = '';
  String _xyEnd = '';
  bool correct = false;

  // movement level
  String _xy = '';
  String _vel = '';
  List<List<dynamic>> _logRows = [];
  List<dynamic> _logRow = [];

  ExperimentDataHandler(this.subject);
}
