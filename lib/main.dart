import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touchtracker/src/experimentstorage.dart';
import 'src/config/firebase_options.dart';
import 'package:vector_math/vector_math.dart';
import 'package:flutter/material.dart';
import 'src/experimentlog.dart';
import 'src/stimuli.dart';
import 'src/touchtracker_bloc.dart';

const bool useFirestoreEmulator = true;

Future<void> main() async {
  final ttBloc = TouchTrackerBloc();
  WidgetsFlutterBinding.ensureInitialized();

  if (useFirestoreEmulator) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await FirebaseAuth.instance.signInAnonymously();
  runApp(TouchTrackerApp(bloc: ttBloc));
}

/// This is the main application widget.
class TouchTrackerApp extends StatelessWidget {
  final TouchTrackerBloc bloc;
  const TouchTrackerApp({Key? key, required this.bloc}) : super(key: key);

  static const String _title = 'Touch Tracker';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: TouchTrackerWidget(bloc: bloc),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class TouchTrackerWidget extends StatefulWidget {
  final TouchTrackerBloc bloc;
  const TouchTrackerWidget({Key? key, required this.bloc}) : super(key: key);

  @override
  State<TouchTrackerWidget> createState() => _TouchTrackerWidgetState();
}

/// This is the private State class that goes with TouchTrackerWidget.
class _TouchTrackerWidgetState extends State<TouchTrackerWidget> {
  String _xyStart = '';
  String _xyEnd = '';
  String _xy = '';
  String _vel = '';
  final Stimuli _stimuli = Stimuli();

  final ExperimentLog _log = ExperimentLog("testExp", "testSubj");
  final ExperimentStorageFireBase _logStorage = ExperimentStorageFireBase();

  @override
  Widget build(BuildContext context) {
    _log.startExperiment();
    _log.startTrial();

    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  width: (MediaQuery.of(context).size.width / 2) - 2 * 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 200,
                          width: 200,
                          child: _stimuli.stimulus('candy')),
                    ],
                  ))),
          Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  width: (MediaQuery.of(context).size.width / 2) - 2 * 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 200,
                          width: 200,
                          child: _stimuli.stimulus('candle')),
                    ],
                  ))),
        ],
      ),
      Row(
        children: [
          TextButton(
            child: const Text('Start'),
            onPressed: () {
              _log.startTrial();
              setState(() {
                _xyStart = '';
                _xyEnd = '';
                _xy = '';
                _vel = '';
              });
            },
          ),
          TextButton(
            child: const Text('End'),
            onPressed: () {
              _log.endTrial();
              setState(() {
                _xyStart = '';
                _xyEnd = '';
                _xy = '';
                _vel = '';
              });
            },
          ),
          TextButton(
            child: const Text('Log'),
            onPressed: () {
              _logStorage.write(_log.logRows, key: "testExp");
            },
          ),
          Text('Start: ' + _xyStart, style: const TextStyle(fontSize: 10)),
          Text('Pos: ' + _xy, style: const TextStyle(fontSize: 10)),
          Text('End: ' + _xyEnd, style: const TextStyle(fontSize: 10)),
          Text('Velocity: ' + _vel, style: const TextStyle(fontSize: 10)),
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
