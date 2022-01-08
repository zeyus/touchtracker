import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/experimentlog.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/trialcontroller.dart';
import 'package:touchtracker/src/widgets/audiocue.dart';
import 'package:touchtracker/src/widgets/stimulipairchoice.dart';

// position = position ??
//         Offset(MediaQuery.of(context).size.width / 2 - _circleRadius,
//             MediaQuery.of(context).size.height / 1.25 - _circleRadius);

class TrialPage extends StatelessWidget {
  final StimulusPairTarget stimuli;
  final void Function(bool isCorrect)? onTrialComplete;
  final _dragIndicatorRadius = 40.0;
  const TrialPage({Key? key, required this.stimuli, this.onTrialComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("build triggered for $stimuli");
    return AudioCue(
        audioCache: Provider.of<AudioCache>(context, listen: false),
        stimulusPairTarget: stimuli,
        child: const Center(child: Text('...')),
        childWhenPromptComplete: _buildStimuliPairChoice(context));
  }

  Widget _buildStimuliPairChoice(BuildContext context) {
    return ChangeNotifierProvider<TrialController>(
      create: (BuildContext context) {
        return TrialController(distanceThreshold: 2 * _dragIndicatorRadius);
      },
      builder: (BuildContext context, _) {
        return Consumer<TrialController>(
          builder: (BuildContext context, TrialController controller, _) {
            return StimuliPairChoice(
              stimuli: stimuli,
              dragIndicatorRadius: _dragIndicatorRadius,
              onChoice: (bool isCorrect) {
                onTrialComplete?.call(isCorrect);
                controller.completeTrial(isCorrect);
                Provider.of<ExperimentLog>(context, listen: false).correct =
                    isCorrect;
                Provider.of<ExperimentLog>(context, listen: false).endTrial();
                // to next page...
              },
              onMovementStart: () {
                Provider.of<ExperimentLog>(context, listen: false).startTrial();
                Provider.of<ExperimentLog>(context, listen: false)
                    .addTrackingEvent(controller.startXY);
                debugPrint("DragStart");
              },
              onMovement: (x, y) {
                Provider.of<ExperimentLog>(context, listen: false)
                    .addTrackingEvent(controller.curXY);
              },
            );
          },
        );
      },
    );
    //
  }
}
