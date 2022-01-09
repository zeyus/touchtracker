import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/experimentlog.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/trialcontroller.dart';
import 'package:touchtracker/src/widgets/audiocue.dart';
import 'package:touchtracker/src/widgets/stimulipairchoice.dart';

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
              key: Key(key.toString() + stimuli.toString()),
              stimuli: stimuli,
              dragIndicatorRadius: _dragIndicatorRadius,
              onChoice: (bool isCorrect) {
                controller.completeTrial(isCorrect);
                Provider.of<ExperimentLog>(context, listen: false).correct =
                    isCorrect;
                Provider.of<ExperimentLog>(context, listen: false).endTrial();
              },
              onMovementStart: () {
                Provider.of<ExperimentLog>(context, listen: false).startTrial(
                  cue: stimuli.toString(),
                  condition: stimuli.pairType.toString(),
                );
                Provider.of<ExperimentLog>(context, listen: false)
                    .addTrackingEvent(controller.startXY);
                debugPrint("DragStart");
              },
              onMovement: (x, y) {
                if (controller.isComplete) {
                  return;
                }
                controller.updateDistance(x, y);
                Provider.of<ExperimentLog>(context, listen: false)
                    .addTrackingEvent(controller.curXY);
              },
              onMovementCancelled: (offset) {
                if (!controller.isComplete) {
                  controller.updatePosition(offset);
                } else {
                  onTrialComplete?.call(controller.isCorrect);
                }
              },
            );
          },
        );
      },
    );
    //
  }
}
