import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/experimentstorage.dart';
// import 'package:touchtracker/src/config/firebase_options.dart';
import 'package:touchtracker/src/widgets/audioprompt.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:touchtracker/src/experimentlog.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/touchtracker_bloc.dart';
import 'package:flutter/services.dart';

const bool useFirestoreEmulator = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  // if (useFirestoreEmulator) {
  //   await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform);
  //   FirebaseFirestore.instance.settings = const Settings(
  //       host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  // } else {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }
  // await FirebaseAuth.instance.signInAnonymously();
  runApp(const TouchTrackerApp());
}

/// This is the main application widget.
class TouchTrackerApp extends StatelessWidget {
  const TouchTrackerApp({Key? key}) : super(key: key);

  static const String _title = 'Touch Tracker';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MultiProvider(
      providers: [
        Provider<ExperimentLog>(create: (_) => ExperimentLog('CandyCandle')),
        Provider<ExperimentStorageCSV>(create: (_) => ExperimentStorageCSV()),
      ],
      child: const MaterialApp(title: _title, home: ExperimentStartWidget()),
    );
  }
}

class ExperimentStartWidget extends StatefulWidget {
  const ExperimentStartWidget({Key? key}) : super(key: key);
  @override
  _ExperimentStartWidget createState() => _ExperimentStartWidget();
}

class _ExperimentStartWidget extends State<ExperimentStartWidget> {
  final _formKey = GlobalKey<FormState>();
  final participantController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    participantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Touch Tracker',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: participantController,
                  decoration: const InputDecoration(
                    labelText: "Participant ID",
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Participant ID cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Start Experiment'),
                onPressed: () {
                  final participant = participantController.text;
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    debugPrint("adding participant $participant");
                    Provider.of<ExperimentLog>(context, listen: false).subject =
                        participant;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiProvider(providers: [
                                Provider<ExperimentLog>.value(
                                    value: Provider.of<ExperimentLog>(context,
                                        listen: false)),
                                Provider<ExperimentStorageCSV>.value(
                                    value: Provider.of<ExperimentStorageCSV>(
                                        context,
                                        listen: false)),
                              ], child: TouchTrackerWidget())),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                        content: const Text('Please enter a participant ID'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner(),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class TouchTrackerWidget extends StatefulWidget {
  final Stimuli _stimuli = Stimuli();
  late final TouchTrackerBloc bloc;
  // final _audioPrompt = AudioPrompt();

  TouchTrackerWidget({Key? key}) : super(key: key) {
    bloc = TouchTrackerBloc(stimuli: _stimuli);
  }

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
  Offset? position;
  bool _overA = false;
  bool _overB = false;
  bool _stimuliVisible = false;
  bool _promptPlaying = false;
  bool _promptFinished = false;

  static const double _circleRadius = 20.0;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  final AudioPrompt _audioPrompt = AudioPrompt();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      debugPrint("Starting experiment log...");
      Provider.of<ExperimentLog>(context, listen: false).startExperiment();
    });

    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page!;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<ExperimentLog>(context).startTrial();

    position = position ??
        Offset(MediaQuery.of(context).size.width / 2 - _circleRadius,
            MediaQuery.of(context).size.height / 1.25 - _circleRadius);

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
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  itemCount: targets.length,
                  itemBuilder: (context, index) {
                    return _buildStimuli(targets[index]);
                  });
            }));
  }

  Widget _buildStimuli(StimulusPairTarget stimuli) {
    debugPrint("build triggered for $stimuli");
    return ChangeNotifierProvider.value(
      value: _audioPrompt,
      child: Consumer<AudioPrompt>(
        builder: (_, audioPrompt, __) {
          return audioPrompt.playerState == PlayerState.COMPLETED
              ? _stimuliScreen(stimuli)
              : _stimuliAudioPrompt(stimuli);
        },
      ),
    );
  }

  Widget _stimuliAudioPrompt(StimulusPairTarget stimuli) {
    _audioPrompt.play(stimuli);
    return const Center(child: Text('...'));
  }

  Widget _stimuliScreen(StimulusPairTarget stimuli) {
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
        Positioned(
          left: position!.dx,
          top: position!.dy,
          child: SizedBox(
            width: _circleRadius * 2,
            height: _circleRadius * 2,
            child:
                // add button to navigate to next page
                GestureDetector(
              child: Draggable<bool>(
                data: true,
                child: const CircleAvatar(
                    radius: _circleRadius,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.black),
                feedback: const CircleAvatar(
                    radius: _circleRadius,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.black),
                childWhenDragging: const CircleAvatar(
                    radius: _circleRadius,
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.grey),
                onDragStarted: () {
                  Provider.of<ExperimentLog>(context, listen: false)
                      .startTrial();

                  Provider.of<ExperimentLog>(context, listen: false)
                      .addTrackingEvent(Vector2(position!.dx, position!.dy));
                  setState(() {
                    debugPrint("DragStart");
                    _stimuliVisible = true;
                  });
                },
                onDragUpdate: (DragUpdateDetails d) {
                  Provider.of<ExperimentLog>(context, listen: false)
                      .addTrackingEvent(
                          Vector2(d.globalPosition.dx, d.globalPosition.dy));
                },
                onDraggableCanceled: (Velocity velocity, Offset offset) {
                  debugPrint("DragCancelled");
                  setState(() => position = offset);
                },
              ),
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
              Navigator.pop(context);
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
                _promptPlaying = false;
                _promptFinished = false;
                _stimuliVisible = false;
              });
            },
          ),
        ),
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
          child: SizedBox(
            width: (MediaQuery.of(context).size.width / 2) - 2 * 22,
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: DragTarget(
                      builder: (context, candidateData, rejectedData) {
                        return Center(
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: widget.bloc.stimuli.stimulus(stimulus),
                          ),
                        );
                      },
                      onAccept: (data) {
                        Provider.of<ExperimentLog>(context, listen: false)
                            .endTrial();
                        if (controller.page! + 1 < totalPages) {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 1),
                              curve: Curves.linear);
                        }
                        setState(() {
                          position = null;
                          _promptPlaying = false;
                          _promptFinished = false;
                          _stimuliVisible = false;
                          _audioPrompt.resetState();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
