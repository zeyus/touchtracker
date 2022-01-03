import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:touchtracker/src/experimentstorage.dart';
import 'package:touchtracker/src/config/firebase_options.dart';
import 'package:touchtracker/src/widgets/hoverable.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:touchtracker/src/experimentlog.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/touchtracker_bloc.dart';
import 'package:flutter/services.dart';

const bool useFirestoreEmulator = true;

Future<void> main() async {
  final Stimuli _stimuli = Stimuli();
  final ttBloc = TouchTrackerBloc(stimuli: _stimuli);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

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
  var currentPageValue = 0.0;
  var totalPages = 0.0;
  bool _overA = false;
  bool _overB = false;
  bool _stimuliVisible = false;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  final ExperimentLog _log = ExperimentLog("testExp", "testSubj");
  final ExperimentStorageFireBase _logStorage = ExperimentStorageFireBase();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _log.startExperiment();
    _log.startTrial();

    return Scaffold(
        appBar: null,
        body: StreamBuilder<UnmodifiableListView<StimulusPairTarget>>(
            stream: widget.bloc.targets,
            initialData: UnmodifiableListView<StimulusPairTarget>([]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              UnmodifiableListView<StimulusPairTarget>? targets = snapshot.data;
              if (targets == null) {
                return const Text('Something went wrong!');
              }
              totalPages = targets.length.toDouble();
              return PageView.builder(
                controller: controller,
                itemCount: targets.length,
                itemBuilder: (context, index) => _buildStimuli(targets[index]),
              );
            }));
  }

  Widget _buildStimuli(StimulusPairTarget stimuli) {
    return Stack(
      key: Key(stimuli.title),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStimulus(stimuli, Target.a),
            _buildStimulus(stimuli, Target.b),
          ],
        ),
        Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child:
                // add button to navigate to next page
                GestureDetector(
              child: const Draggable<bool>(
                data: true,
                child: CircleAvatar(
                    radius: 10,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.black),
                feedback: CircleAvatar(
                    radius: 10,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.black),
                childWhenDragging: CircleAvatar(
                    radius: 10,
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.grey),
              ),
              onTapDown: (details) {
                _log.startTrial();
                setState(() {
                  debugPrint("Circle tap down");
                  _stimuliVisible = true;
                });
              },
              onTap: () {
                debugPrint("Circle tap");
                // show only if there is a next page
                if (controller.page! + 1 < totalPages) {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.linear);
                } else {
                  controller.animateToPage(0,
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.linear);
                }
              },
              onTapUp: (details) {
                debugPrint("Circle tap up");
                setState(() {
                  _stimuliVisible = false;
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "${stimuli.title} ${currentPageValue.toInt() + 1}/${totalPages.toInt()}",
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: ElevatedButton(
            child: const Text("reset"),
            onPressed: () {
              controller.animateToPage(0,
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.linear);
              setState(() {
                _stimuliVisible = false;
              });
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            child: const Text("last"),
            onPressed: () {
              controller.animateToPage(totalPages.toInt(),
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.linear);
              setState(() {
                _stimuliVisible = false;
              });
            },
          ),
        ),
        GestureDetector(onPanStart: (DragStartDetails d) {
          debugPrint("Generic pan start");
          if (_stimuliVisible) {
            setState(() {
              _xyStart = _xy = d.globalPosition.dx.round().toString() +
                  ', ' +
                  d.globalPosition.dy.round().toString();
              _log.addTrackingEvent(
                  Vector2(d.globalPosition.dx, d.globalPosition.dy));
            });
          }
        }, onPanUpdate: (DragUpdateDetails d) {
          if (_stimuliVisible) {
            setState(() {
              _xy = d.globalPosition.dx.round().toString() +
                  ', ' +
                  d.globalPosition.dy.round().toString();
              _log.addTrackingEvent(
                  Vector2(d.globalPosition.dx, d.globalPosition.dy));
            });
          }
        }, onPanEnd: (DragEndDetails d) {
          debugPrint("Generic pan end");
          if (_stimuliVisible) {
            setState(() {
              _xyEnd = _xy;
              _vel = d.velocity.toString();
              if (_overA || _overB) {
                _log.endTrial();
                if (controller.page! + 1 < totalPages) {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.linear);
                }
                _log.debugLog();
                setState(() {
                  _stimuliVisible = false;
                });
                return;
              }

              //debug code
              _log.debugLog();
            });
          }
        })
      ],
    );
  }

  Widget _buildStimulus(StimulusPairTarget stimuli, Target which) {
    final String stimulus = which == Target.a ? stimuli.a : stimuli.b;
    final CrossAxisAlignment alignment =
        which == Target.a ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _stimuliVisible,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: SizedBox(
              width: (MediaQuery.of(context).size.width / 2) - 2 * 20,
              child: Column(
                crossAxisAlignment: alignment,
                children: [
                  SizedBox(
                      height: 200,
                      width: 200,
                      child: Hoverable(
                          onHover: () {
                            debugPrint("Target $which hovered");
                            setState(() {
                              _overA = which == Target.a;
                              _overB = which == Target.b;
                            });
                          },
                          onExit: () {
                            debugPrint("Target $which hover exit");
                            setState(() {
                              _overA = false;
                              _overB = false;
                            });
                          },
                          child: widget.bloc.stimuli.stimulus(stimulus))),
                ],
              ),
            ),
          ),
        ));
  }
}




// Stack(children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//               padding: const EdgeInsets.all(20),
//               child: SizedBox(
//                   width: (MediaQuery.of(context).size.width / 2) - 2 * 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                           height: 200,
//                           width: 200,
//                           child: _stimuli.stimulus('candy')),
//                     ],
//                   ))),
//           Padding(
//               padding: const EdgeInsets.all(20),
//               child: SizedBox(
//                   width: (MediaQuery.of(context).size.width / 2) - 2 * 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       SizedBox(
//                           height: 200,
//                           width: 200,
//                           child: _stimuli.stimulus('candle')),
//                     ],
//                   ))),
//         ],
//       ),
//       Row(
//         children: [
//           TextButton(
//             child: const Text('Start'),
//             onPressed: () {
//               _log.startTrial();
//               setState(() {
//                 _xyStart = '';
//                 _xyEnd = '';
//                 _xy = '';
//                 _vel = '';
//               });
//             },
//           ),
//           TextButton(
//             child: const Text('End'),
//             onPressed: () {
//               _log.endTrial();
//               setState(() {
//                 _xyStart = '';
//                 _xyEnd = '';
//                 _xy = '';
//                 _vel = '';
//               });
//             },
//           ),
//           TextButton(
//             child: const Text('Log'),
//             onPressed: () {
//               _logStorage.write(_log.logRows, key: "testExp");
//             },
//           ),
//           Text('Start: ' + _xyStart, style: const TextStyle(fontSize: 10)),
//           Text('Pos: ' + _xy, style: const TextStyle(fontSize: 10)),
//           Text('End: ' + _xyEnd, style: const TextStyle(fontSize: 10)),
//           Text('Velocity: ' + _vel, style: const TextStyle(fontSize: 10)),
//         ],
//       ),
//       GestureDetector(onPanStart: (DragStartDetails d) {
//         setState(() {
//           _xyStart = _xy = d.globalPosition.dx.round().toString() +
//               ', ' +
//               d.globalPosition.dy.round().toString();
//           _log.addTrackingEvent(
//               Vector2(d.globalPosition.dx, d.globalPosition.dy));
//         });
//       }, onPanUpdate: (DragUpdateDetails d) {
//         setState(() {
//           _xy = d.globalPosition.dx.round().toString() +
//               ', ' +
//               d.globalPosition.dy.round().toString();
//           _log.addTrackingEvent(
//               Vector2(d.globalPosition.dx, d.globalPosition.dy));
//         });
//       }, onPanEnd: (DragEndDetails d) {
//         setState(() {
//           _xyEnd = _xy;
//           _vel = d.velocity.toString();
//           _log.endTrial();
//           //debug code
//           _log.debugLog();
//         });
//       })
//     ]);