import 'dart:collection';
import 'package:flutter/foundation.dart';

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
        Provider<AudioPrompt>(create: (_) => AudioPrompt()),
        Provider<ExperimentStorage>(create: (_) => getStorage()),
      ],
      child: Consumer<ExperimentStorage>(builder: (_, storage, __) {
        return Provider<ExperimentLog>(
            create: (_) =>
                ExperimentLog(storage: storage, experimentId: 'CandyCandle'),
            child: const MaterialApp(
                title: _title, home: ExperimentStartWidget()));
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
  String _selectedGender = '';

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
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
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
                                if (value == 'o') {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Other'),
                                          content: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Please specify',
                                            ),
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "Please specify";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.text,
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ElevatedButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                }
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: "Age"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                      ),
                    ],
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
                          .subjectId = participant;
                      // condition, in this case it's always experimental
                      Provider.of<ExperimentLog>(context, listen: false)
                          .condition = 'experimental';
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersive);
                      participantController.clear();
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
              return PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  itemCount: targets.length,
                  itemBuilder: (context, index) {
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
