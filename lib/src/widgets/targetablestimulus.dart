import 'package:flutter/material.dart';
import 'package:touchtracker/src/stimuli.dart';

class TargetableStimulus extends StatelessWidget {
  final StimulusPairTarget stimuli;
  final Target which;
  final bool visibility;
  final void Function(bool isCorrect) onStimulusReached;
  final Widget child;
  const TargetableStimulus(
      {Key? key,
      required this.stimuli,
      required this.which,
      required this.visibility,
      required this.onStimulusReached,
      required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final String stimulus = stimuli.getFromTarget(which);
    final CrossAxisAlignment alignment =
        which == Target.a ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibility,
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
                            child: child,
                          ),
                        );
                      },
                      onWillAccept: (_) {
                        onStimulusReached(stimuli.target == which);
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

// pass this to child:
// widget.bloc.stimuli.stimulus(stimulus)

// pass this to onstimulusreached.
// (data) {
//                         bool isCorrect = false;
//                         if (stimulus == stimuli.getTargetStimulus()) {
//                           isCorrect = true;
//                         }
//                         Provider.of<ExperimentLog>(context, listen: false)
//                             .correct = isCorrect;
//                         Provider.of<ExperimentLog>(context, listen: false)
//                             .endTrial();

//                         if (controller.page! + 1 < totalPages) {
//                           debugPrint("Next page...");
//                           setState(() {
//                             debugPrint("reset stim pos setstate callback...");
//                             position = null;
//                             _stimuliVisible = false;
//                           });
//                           Provider.of<AudioPrompt>(context, listen: false)
//                               .resetState()
//                               .then((_) {
//                             debugPrint("reset stim pos...");
//                             controller.nextPage(
//                                 duration: const Duration(milliseconds: 1),
//                                 curve: Curves.linear);
//                           });
//                         } else {
//                           Provider.of<ExperimentLog>(context, listen: false)
//                               .endExperiment();
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => MultiProvider(providers: [
//                                       Provider<ExperimentLog>.value(
//                                           value: Provider.of<ExperimentLog>(
//                                               context,
//                                               listen: false)),
//                                       Provider<ExperimentStorage>.value(
//                                           value: Provider.of<ExperimentStorage>(
//                                               context,
//                                               listen: false)),
//                                       ChangeNotifierProvider<AudioPrompt>.value(
//                                           value: Provider.of<AudioPrompt>(
//                                               context,
//                                               listen: false)),
//                                     ], child: const ThankYouWidget())),
//                           );
//                         }