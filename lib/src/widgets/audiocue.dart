import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/audioprompt.dart';
import 'package:touchtracker/src/controller/trialcontroller.dart';
import 'package:touchtracker/src/stimuli.dart';

class AudioCue extends StatelessWidget {
  final StimulusPairTarget stimulusPairTarget;
  final Widget child;
  final Widget childWhenPromptComplete;

  const AudioCue({
    Key? key,
    required this.stimulusPairTarget,
    required this.child,
    required this.childWhenPromptComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<TrialController>(context, listen: false).promptComplete) {
      return childWhenPromptComplete;
    } else if (!Provider.of<TrialController>(context, listen: false)
        .promptStarted) {
      Provider.of<TrialController>(context)
          .playPrompt(Provider.of<AudioPrompt>(context, listen: false));
    }
    return child;
  }
}
