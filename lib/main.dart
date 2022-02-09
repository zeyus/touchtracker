import 'dart:collection';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'package:provider/provider.dart';
import 'package:touchtracker/src/audioprompt.dart';
import 'package:touchtracker/src/storage/experimentstorage.dart';

import 'package:touchtracker/src/widgets/trialpage.dart';

import 'package:flutter/material.dart';
import 'package:touchtracker/src/experimentlog.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/bloc/touchtracker_bloc.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  List<String> allStimuli = Stimuli.stimuli;
  List<AudioSource> audioSources = [];

  // prepare audio pipeline
  final session = await AudioSession.instance;

  await session.configure(const AudioSessionConfiguration.speech().copyWith(
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
    avAudioSessionMode: AVAudioSessionMode.voicePrompt,
    avAudioSessionRouteSharingPolicy:
        AVAudioSessionRouteSharingPolicy.independent,
    androidAudioAttributes: const AndroidAudioAttributes(
      contentType: AndroidAudioContentType.sonification,
      usage: AndroidAudioUsage.notificationCommunicationInstant,
      flags: AndroidAudioFlags(1 & 256),
    ),
    androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientExclusive,
  ));

  for (String stimulus in allStimuli) {
    audioSources.add(AudioSource.uri(Uri.parse(
        'asset:///${AudioPrompt.assetPath}$stimulus${AudioPrompt.fileExtension}')));
  }

  runApp(TouchTrackerApp(audioSources: audioSources));
}

/// This is the main application widget.
class TouchTrackerApp extends StatelessWidget {
  final List<AudioSource> audioSources;
  const TouchTrackerApp({Key? key, required this.audioSources})
      : super(key: key);

  static const String _title = 'Touch Tracker';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioPrompt>(
          create: (_) => AudioPrompt(audioSources: audioSources),
          dispose: (context, audioPrompt) => audioPrompt.dispose(),
        ),
        Provider<ExperimentStorage>(create: (_) => getStorage()),
      ],
      child: Consumer<ExperimentStorage>(builder: (_, storage, __) {
        return Provider<ExperimentLog>(
            create: (_) =>
                ExperimentLog(storage: storage, experimentId: 'CandyCandle'),
            child: const MaterialApp(
                debugShowCheckedModeBanner: false,
                title: _title,
                home: ExperimentStartWidget()));
      }),
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
  final genderOtherController = TextEditingController();
  final ageController = TextEditingController();
  String _selectedGender = '';
  String _selectedHandedness = '';

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
                  child: Column(
                    children: [
                      TextFormField(
                        controller: participantController,
                        decoration: const InputDecoration(
                          labelText: "Participant ID",
                          icon: Icon(Icons.people),
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
                      Row(
                        // participant age textformfield
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: ageController,
                              decoration: const InputDecoration(
                                labelText: "Age",
                                icon: Icon(Icons.timer),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Age cannot be empty";
                                } else {
                                  if (int.tryParse(val) == null) {
                                    return "Age must be a number";
                                  } else {
                                    if (int.tryParse(val)! < 1 ||
                                        int.tryParse(val)! > 110) {
                                      return "Age must be between 1 and 110";
                                    } else {
                                      return null;
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: "Gender",
                                icon: Icon(Icons.question_answer),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please select a gender";
                                } else {
                                  return null;
                                }
                              },
                              isExpanded: true,
                              value: _selectedGender,
                              items: const <DropdownMenuItem<String>>[
                                DropdownMenuItem<String>(
                                  value: '',
                                  enabled: true,
                                  child: Text(
                                    'Select your gender...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'f',
                                  child: Text('Female'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'm',
                                  child: Text('Male'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'n',
                                  child: Text('Non-binary'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'o',
                                  child: Text('Other (please specify)'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [Expanded(child: _buildOtherGenderField())],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: "Handedness",
                                icon: Icon(Icons.clean_hands),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please select handedness";
                                } else {
                                  return null;
                                }
                              },
                              isExpanded: true,
                              value: _selectedHandedness,
                              items: const <DropdownMenuItem<String>>[
                                DropdownMenuItem<String>(
                                  value: '',
                                  enabled: true,
                                  child: Text(
                                    'Select your handedness...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'left',
                                  child: Text('Left-handed'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'm',
                                  child: Text('Right-handed'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'ambidextrous',
                                  child: Text('Ambidextrous'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedHandedness = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  child: const Text('Start Experiment'),
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      final participant = participantController.text;
                      final age = int.tryParse(ageController.text);
                      final String gender;
                      switch (_selectedGender) {
                        case 'f':
                          gender = "female";
                          break;
                        case 'm':
                          gender = "male";
                          break;
                        case 'n':
                          gender = "non-binary";
                          break;
                        case 'o':
                          gender = genderOtherController.text;
                          break;
                        default:
                          throw Exception(
                              "No gender selected but validation passed.");
                      }
                      final handedness = _selectedHandedness;

                      debugPrint(
                          "adding participant $participant, age: $age, gender: $gender, handedness: $handedness.");
                      Provider.of<ExperimentLog>(context, listen: false)
                          .subjectId = participant;
                      Provider.of<ExperimentLog>(context, listen: false)
                          .subjectAge = age;
                      Provider.of<ExperimentLog>(context, listen: false)
                          .subjectGender = gender;
                      Provider.of<ExperimentLog>(context, listen: false)
                          .subjectHandedness = handedness;
                      // condition, in this case it's always experimental
                      Provider.of<ExperimentLog>(context, listen: false)
                          .condition = 'experimental';
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersive);
                      participantController.clear();
                      ageController.clear();
                      genderOtherController.clear();
                      setState(() {
                        _selectedGender = '';
                        _selectedHandedness = '';
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiProvider(providers: [
                                  Provider<AudioPrompt>.value(
                                      value: Provider.of<AudioPrompt>(context,
                                          listen: false)),
                                  Provider<ExperimentLog>.value(
                                      value: Provider.of<ExperimentLog>(context,
                                          listen: false)),
                                  Provider<ExperimentStorage>.value(
                                      value: Provider.of<ExperimentStorage>(
                                          context,
                                          listen: false)),
                                ], child: TouchTrackerWidget())),
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

  Widget _buildOtherGenderField() {
    if (_selectedGender != 'o') {
      return Container();
    }

    return TextFormField(
      controller: genderOtherController,
      decoration: const InputDecoration(
        labelText: "Please specify gender",
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Please select gender from the list or fill in \"other\"";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.text,
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class TouchTrackerWidget extends StatefulWidget {
  final Stimuli _stimuli = Stimuli();
  late final TouchTrackerBloc bloc;

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

  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      debugPrint("Starting experiment log...");
      Provider.of<ExperimentLog>(context, listen: false).start();
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
              Provider.of<AudioPrompt>(context, listen: false)
                  .loadExperiment(targets);
              return PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  itemCount: targets.length,
                  itemBuilder: (context, index) {
                    Provider.of<AudioPrompt>(context, listen: false)
                        .currentIndex = index;
                    return MultiProvider(
                        providers: [
                          Provider<AudioPrompt>.value(
                              value: Provider.of<AudioPrompt>(context,
                                  listen: false)),
                          Provider<Stimuli>.value(value: widget._stimuli),
                        ],
                        builder: (context, child) => TrialPage(
                            key: Key('TrialPage:$index'),
                            stimuli: targets[index],
                            nextStimuli: index < targets.length - 1
                                ? targets[index + 1]
                                : null,
                            onTrialComplete: (bool isCorrect,
                                {bool endExperiment = false}) {
                              _onTrialComplete(context,
                                  endExperiment: endExperiment);
                            }));
                  });
            }));
  }

  void _onTrialComplete(BuildContext context, {bool endExperiment = false}) {
    Provider.of<AudioPrompt>(context, listen: false).resetState();
    if (!endExperiment && controller.page! + 1 < totalPages) {
      controller.nextPage(
          duration: const Duration(milliseconds: 1), curve: Curves.linear);
    } else {
      _endExperiment(context);
      _goToThankYouPage(context);
    }
  }

  void _endExperiment(BuildContext context) {
    debugPrint("Ending experiment...");
    Provider.of<ExperimentLog>(context, listen: false).end();
  }

  void _goToThankYouPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MultiProvider(providers: [
                Provider<AudioPrompt>.value(
                    value: Provider.of<AudioPrompt>(context, listen: false)),
                Provider<ExperimentLog>.value(
                    value: Provider.of<ExperimentLog>(context, listen: false)),
                Provider<ExperimentStorage>.value(
                    value:
                        Provider.of<ExperimentStorage>(context, listen: false)),
              ], child: const ThankYouWidget())),
    );
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
