import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/experimentlog.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/controller/trialcontroller.dart';
import 'package:touchtracker/src/widgets/audiocue.dart';
import 'package:touchtracker/src/widgets/stimulipairchoice.dart';

class TrialPage extends StatelessWidget {
  final StimulusPairTarget stimuli;
  final StimulusPairTarget? nextStimuli;
  final void Function(bool isCorrect, {bool endExperiment})? onTrialComplete;
  final _dragIndicatorRadius = 40.0;
  const TrialPage(
      {Key? key, required this.stimuli, this.onTrialComplete, this.nextStimuli})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("build triggered for $stimuli");
    return ChangeNotifierProvider<TrialController>(
        create: (BuildContext context) {
      return TrialController(
          distanceThreshold: 1.5 * _dragIndicatorRadius,
          stimuli: stimuli,
          nextStimuli: nextStimuli);
    }, builder: (context, _) {
      return Consumer<TrialController>(
          builder: (BuildContext context, TrialController controller, _) {
        return AudioCue(
            key: Key(key.toString() + stimuli.toString() + "audio"),
            stimulusPairTarget: stimuli,
            child: const Center(child: Text('...')),
            childWhenPromptComplete:
                _buildStimuliPairChoice(context, controller));
      });
    });
  }

  Widget _buildStimuliPairChoice(
      BuildContext context, TrialController controller) {
    return StimuliPairChoice(
        key: Key(key.toString() + stimuli.toString()),
        stimuli: stimuli,
        dragIndicatorRadius: _dragIndicatorRadius,
        onChoice: (bool isCorrect, {bool endExperiment = false}) {
          debugPrint("onchoice complete trial");
          controller.completeTrial(isCorrect);
          Provider.of<ExperimentLog>(context, listen: false)
              .trialEnd(correct: isCorrect);
          if (endExperiment) {
            onTrialComplete?.call(controller.isCorrect, endExperiment: true);
          }
          // fix for race condition
          // if the movement was cancelled but somehow the
          // dragtarget onwillaccept was triggered after
          // it has happened before and left the experiment
          // stuck on the "complete" page.
          if (controller.movementCancelled) {
            debugPrint("onchoice calling ontrialcomplete");
            controller.trialCompleteCalled = true;
            onTrialComplete?.call(controller.isCorrect);
          }
        },
        onMovementStart: () {
          controller.movementCancelled = false;
          Provider.of<ExperimentLog>(context, listen: false).displayDetails(
              w: MediaQuery.of(context).size.width,
              h: MediaQuery.of(context).size.height,
              dpi: MediaQuery.of(context).devicePixelRatio * 160,
              // @TODO: allow for web fullscreen (wrap like logwriter).
              fullscreen: kIsWeb == false);

          Provider.of<ExperimentLog>(context, listen: false)
              .trialStart(stimuli);
          debugPrint("DragStart");
        },
        onMovement: (x, y) {
          if (controller.isComplete) {
            return;
          }
          controller.updateDistance(x, y);
          Provider.of<ExperimentLog>(context, listen: false)
              .track(controller.curXY);
        },
        onMovementCancelled: (offset) {
          debugPrint("onmovementcancelled");
          if (!controller.isComplete) {
            controller.updatePosition(offset);
            // fix for race condition
            // this is only if the movement is cancelled
            // before triggering the drag target's onWillAccept.
            controller.movementCancelled = true;
          } else {
            debugPrint("onmovementcancelled complete trial");
            controller.trialCompleteCalled = true;
            onTrialComplete?.call(controller.isCorrect);
          }
        },
        onMovementTerminated: () {
          debugPrint("onmovementterminated");
          if (controller.isComplete && !controller.trialCompleteCalled) {
            controller.trialCompleteCalled = true;
            onTrialComplete?.call(controller.isCorrect);
          }
        });
  }
}
