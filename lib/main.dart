import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:touchtracker/src/experimentstorage.dart';

import 'package:touchtracker/src/widgets/audioprompt.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:touchtracker/src/experimentlog.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/touchtracker_bloc.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const TouchTrackerApp());
}

/// This is the main application widget.
class TouchTrackerApp extends StatelessWidget {
  const TouchTrackerApp({Key? key}) : super(key: key);

  static const String _title = 'Touch Tracker';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ExperimentLog>(create: (_) => ExperimentLog('CandyCandle')),
        Provider<ExperimentStorage>(create: (_) => getStorage()),
        ChangeNotifierProvider<AudioPrompt>(create: (_) => AudioPrompt()),
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
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
          }
        }
      },
      child: Scaffold(
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
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner(
                        reason: MaterialBannerClosedReason.dismiss);
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      debugPrint("adding participant $participant");
                      Provider.of<ExperimentLog>(context, listen: false)
                          .subject = participant;
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersive);
                      participantController.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiProvider(providers: [
                                  Provider<ExperimentLog>.value(
                                      value: Provider.of<ExperimentLog>(context,
                                          listen: false)),
                                  Provider<ExperimentStorage>.value(
                                      value: Provider.of<ExperimentStorage>(
                                          context,
                                          listen: false)),
                                  ChangeNotifierProvider<AudioPrompt>.value(
                                      value: Provider.of<AudioPrompt>(context,
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
  var currentPageValue = 0.0;
  var totalPages = 0.0;
  Offset? position;
  bool _stimuliVisible = false;

  static const double _circleRadius = 40.0;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  //final AudioPrompt _audioPrompt = AudioPrompt();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      debugPrint("Starting experiment log...");
      Provider.of<ExperimentLog>(context, listen: false).startExperiment(
          Provider.of<ExperimentStorage>(context, listen: false));
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
      value: Provider.of<AudioPrompt>(context),
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
    Provider.of<AudioPrompt>(context, listen: false).play(stimuli);
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
                  debugPrint("DragStart");
                },
                onDragUpdate: (DragUpdateDetails d) {
                  Provider.of<ExperimentLog>(context, listen: false)
                      .addTrackingEvent(
                          Vector2(d.globalPosition.dx, d.globalPosition.dy));

                  if (!_stimuliVisible && position != null) {
                    // debugPrint(
                    //     "position: ${position!.dx}, ${position!.dy}, d.globalPosition: ${d.globalPosition.dx}, ${d.globalPosition.dy}, d.localPosition: ${d.localPosition.dx}, ${d.localPosition.dy}");
                    if (max((d.localPosition.dx - position!.dx).abs(),
                            (d.localPosition.dy - position!.dy).abs()) >
                        _circleRadius * 1.5) {
                      setState(() {
                        _stimuliVisible = true;
                      });
                    }
                  }
                },
                onDraggableCanceled: (Velocity velocity, Offset offset) {
                  debugPrint("DragCancelled");
                  if (_stimuliVisible) {
                    setState(() => position = offset);
                  }
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
            child: const Text("Back to Home"),
            onPressed: () {
              Provider.of<ExperimentLog>(context, listen: false).endTrial();
              Provider.of<ExperimentLog>(context, listen: false)
                  .endExperiment();
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
              Navigator.pop(context);
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            child: const Text("Thank you page"),
            onPressed: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
              Provider.of<ExperimentLog>(context, listen: false).endTrial();
              Provider.of<ExperimentLog>(context, listen: false)
                  .endExperiment();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MultiProvider(providers: [
                          Provider<ExperimentLog>.value(
                              value: Provider.of<ExperimentLog>(context,
                                  listen: false)),
                          Provider<ExperimentStorage>.value(
                              value: Provider.of<ExperimentStorage>(context,
                                  listen: false)),
                          ChangeNotifierProvider<AudioPrompt>.value(
                              value: Provider.of<AudioPrompt>(context,
                                  listen: false)),
                        ], child: const ThankYouWidget())),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStimulus(StimulusPairTarget stimuli, Target which) {
    final String stimulus = stimuli.getFromTarget(which);
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
                      onWillAccept: (data) {
                        bool isCorrect = false;
                        if (stimulus == stimuli.getTargetStimulus()) {
                          isCorrect = true;
                        }
                        Provider.of<ExperimentLog>(context, listen: false)
                            .correct = isCorrect;
                        Provider.of<ExperimentLog>(context, listen: false)
                            .endTrial();
                        Provider.of<AudioPrompt>(context, listen: false)
                            .resetState();
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersive);
                        if (controller.page! + 1 < totalPages) {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 1),
                              curve: Curves.linear);
                        } else {
                          Provider.of<ExperimentLog>(context, listen: false)
                              .endExperiment();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiProvider(providers: [
                                      Provider<ExperimentLog>.value(
                                          value: Provider.of<ExperimentLog>(
                                              context,
                                              listen: false)),
                                      Provider<ExperimentStorage>.value(
                                          value: Provider.of<ExperimentStorage>(
                                              context,
                                              listen: false)),
                                      ChangeNotifierProvider<AudioPrompt>.value(
                                          value: Provider.of<AudioPrompt>(
                                              context,
                                              listen: false)),
                                    ], child: const ThankYouWidget())),
                          );
                        }
                        setState(() {
                          position = null;
                          _stimuliVisible = false;
                        });

                        return true;
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

// thank you page widget
class ThankYouWidget extends StatelessWidget {
  const ThankYouWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Thank you for participating!",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Back to Home"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ..._buildLogLinks(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLogLinks(BuildContext context) {
    List<Widget> links = [];
    links.add(const SizedBox(height: 20));
    links.add(const Text(
      "You can download the log files here:",
      style: TextStyle(fontSize: 20),
    ));
    links.add(const SizedBox(height: 20));
    for (String logFile
        in Provider.of<ExperimentStorage>(context, listen: false).getLogs()) {
      links.add(
        ElevatedButton(
          child: Text(logFile),
          onPressed: () {
            Provider.of<ExperimentStorage>(context, listen: false)
                .openLog(logFile);
          },
        ),
      );
    }
    return links;
  }
}
