import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/controller/trialcontroller.dart';
import 'package:touchtracker/src/widgets/targetablestimulus.dart';

class StimuliPairChoice extends StatelessWidget {
  final StimulusPairTarget stimuli;
  final Function(bool isCorrect, {bool endExperiment})? onChoice;
  final Function? onMovementStart;
  final Function(double x, double y)? onMovement;
  final Function(Offset offset)? onMovementCancelled;
  // either "end" or "completed"...
  final Function? onMovementTerminated;
  final double dragIndicatorRadius;
  const StimuliPairChoice(
      {Key? key,
      required this.stimuli,
      this.onChoice,
      this.onMovementStart,
      this.onMovement,
      this.onMovementCancelled,
      this.onMovementTerminated,
      required this.dragIndicatorRadius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Provider.of<TrialController>(context).isComplete) {
      return const Center(
        child: Text('Complete!'),
      );
    }

    return Stack(
      key: Key(stimuli.title),
      children: [
        _buildPair(context),
        _buildDragIndicator(context),
        _buildDebugButtons(context),
      ],
    );
  }

  Widget _buildPair(BuildContext context) {
    final bool stimuliVisible =
        Provider.of<TrialController>(context).stimuliVisible;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TargetableStimulus(
            stimuli: stimuli,
            which: Target.a,
            visibility: stimuliVisible,
            onStimulusReached: (bool isCorrect) {
              _onChoice(context, isCorrect);
            },
            child: Provider.of<Stimuli>(context, listen: false)
                .stimulus(stimuli.getFromTarget(Target.a))),
        TargetableStimulus(
            stimuli: stimuli,
            which: Target.b,
            visibility: stimuliVisible,
            onStimulusReached: (bool isCorrect) {
              _onChoice(context, isCorrect);
            },
            child: Provider.of<Stimuli>(context, listen: false)
                .stimulus(stimuli.getFromTarget(Target.b))),
      ],
    );
  }

  void _onChoice(BuildContext context, bool isCorrect,
      {bool endExperiment = false}) {
    Provider.of<TrialController>(context, listen: false)
        .completeTrial(isCorrect);
    onChoice?.call(isCorrect, endExperiment: endExperiment);
  }

  Widget _buildDragIndicator(BuildContext context) {
    // @TODO: make more efficient, this should only be set on TrialController create.
    Provider.of<TrialController>(context).updateStartPosition(Offset(
        MediaQuery.of(context).size.width / 2 - dragIndicatorRadius,
        MediaQuery.of(context).size.height / 1.25 - dragIndicatorRadius));

    return Positioned(
      left: Provider.of<TrialController>(context, listen: false).currentPos.dx,
      top: Provider.of<TrialController>(context, listen: false).currentPos.dy,
      child: SizedBox(
        width: dragIndicatorRadius * 2,
        height: dragIndicatorRadius * 2,
        child: Draggable<bool>(
          maxSimultaneousDrags: 1,
          data: true,
          // @TODO: Allow color customization.
          child: CircleAvatar(
              radius: dragIndicatorRadius,
              foregroundColor: Colors.black,
              backgroundColor: Colors.black),
          feedback: CircleAvatar(
              radius: dragIndicatorRadius,
              foregroundColor: Colors.black,
              backgroundColor: Colors.black),
          childWhenDragging: CircleAvatar(
              radius: dragIndicatorRadius,
              foregroundColor: Colors.grey,
              backgroundColor: Colors.grey),
          onDragStarted: () {
            onMovementStart?.call();
          },
          onDragUpdate: (DragUpdateDetails d) {
            onMovement?.call(d.globalPosition.dx, d.globalPosition.dy);
          },
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            onMovementCancelled?.call(offset);
          },
          onDragCompleted: () {
            debugPrint("onDragCompleted");
            onMovementTerminated?.call();
          },
          onDragEnd: (_) {
            debugPrint("onDragEnd");
            onMovementTerminated?.call();
          },
        ),
      ),
    );
  }

  Widget _buildDebugButtons(BuildContext context) {
    if (!kDebugMode) {
      return Container();
    }
    return Row(
      children: [
        Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              child: const Text('End Experiment'),
              onPressed: () {
                _onChoice(context, false, endExperiment: true);
              },
            )),
      ],
    );
  }
}
