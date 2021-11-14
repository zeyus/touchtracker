import 'package:vector_math/vector_math.dart';
import 'package:flutter/material.dart';
import 'experimentlog.dart';

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

  final ExperimentLog _log = ExperimentLog("testExp", "testSubj");

  @override
  Widget build(BuildContext context) {
    _log.startExperiment();
    _log.startTrial();

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
              d.globalPosition.dy.round().toString();
          _log.addTrackingEvent(
              Vector2(d.globalPosition.dx, d.globalPosition.dy));
        });
      }, onPanUpdate: (DragUpdateDetails d) {
        setState(() {
          _xy = d.globalPosition.dx.round().toString() +
              ', ' +
              d.globalPosition.dy.round().toString();
          _log.addTrackingEvent(
              Vector2(d.globalPosition.dx, d.globalPosition.dy));
        });
      }, onPanEnd: (DragEndDetails d) {
        setState(() {
          _xyEnd = _xy;
          _vel = d.velocity.toString();
          _log.endTrial();
          //debug code
          _log.debugLog();
        });
      })
    ]);
  }
}
