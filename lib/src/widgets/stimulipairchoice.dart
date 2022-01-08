import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:touchtracker/src/trialcontroller.dart';
import 'package:touchtracker/src/widgets/targetablestimulus.dart';

class StimuliPairChoice extends StatelessWidget {
  final StimulusPairTarget stimuli;
  final Function(bool isCorrect)? onChoice;
  final Function? onMovementStart;
  final Function(double x, double y)? onMovement;
  final Function? onMovementCancelled;
  final double dragIndicatorRadius;
  const StimuliPairChoice(
      {Key? key,
      required this.stimuli,
      this.onChoice,
      this.onMovementStart,
      this.onMovement,
      this.onMovementCancelled,
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
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Text(
        //     "${stimuli.title} ${currentPageValue.toInt() + 1}/${totalPages.toInt()}",
        //     style: const TextStyle(fontSize: 20),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.bottomLeft,
        //   child: ElevatedButton(
        //     child: const Text("Back to Home"),
        //     onPressed: () {
        //       Provider.of<ExperimentLog>(context, listen: false).endTrial();
        //       Provider.of<ExperimentLog>(context, listen: false)
        //           .endExperiment();
        //       Navigator.pop(context);
        //     },
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: ElevatedButton(
        //     child: const Text("Thank you page"),
        //     onPressed: () {
        //       Provider.of<ExperimentLog>(context, listen: false).endTrial();
        //       Provider.of<ExperimentLog>(context, listen: false)
        //           .endExperiment();
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => MultiProvider(providers: [
        //                   Provider<ExperimentLog>.value(
        //                       value: Provider.of<ExperimentLog>(context,
        //                           listen: false)),
        //                   Provider<ExperimentStorage>.value(
        //                       value: Provider.of<ExperimentStorage>(context,
        //                           listen: false)),
        //                   ChangeNotifierProvider<AudioPrompt>.value(
        //                       value: Provider.of<AudioPrompt>(context,
        //                           listen: false)),
        //                 ], child: const ThankYouWidget())),
        //       );
        //     },
        //   ),
        // ),
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

  void _onChoice(BuildContext context, bool isCorrect) {
    Provider.of<TrialController>(context, listen: false)
        .completeTrial(isCorrect);
    onChoice?.call(isCorrect);
  }

  Widget _buildDragIndicator(BuildContext context) {
    // @TODO: make more efficient, this should only be set on TrialController create.
    Provider.of<TrialController>(context).updateStartPosition(Offset(
        MediaQuery.of(context).size.width / 2 - dragIndicatorRadius,
        MediaQuery.of(context).size.height / 1.25 - dragIndicatorRadius));

    return Positioned(
      left: Provider.of<TrialController>(context, listen: false).currentPos.dx,
      top: Provider.of<TrialController>(context, listen: false).currentPos.dx,
      child: SizedBox(
        width: dragIndicatorRadius * 2,
        height: dragIndicatorRadius * 2,
        child: Draggable<bool>(
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
            Provider.of<TrialController>(context, listen: false)
                .updateDistance(d.globalPosition.dx, d.globalPosition.dy);
            onMovement?.call(d.globalPosition.dx, d.globalPosition.dy);
          },
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            Provider.of<TrialController>(context, listen: false)
                .updatePosition(offset);
            onMovementCancelled?.call();
          },
        ),
      ),
    );
  }
}
