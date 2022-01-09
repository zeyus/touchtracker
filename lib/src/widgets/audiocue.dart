// Main widget for audio player only
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/audioprompt.dart';
import 'package:touchtracker/src/stimuli.dart';

class AudioCue extends StatelessWidget {
  final StimulusPairTarget stimulusPairTarget;
  final Widget child;
  final Widget childWhenPromptComplete;
  final Function? onPromptComplete;

  const AudioCue(
      {Key? key,
      required this.stimulusPairTarget,
      required this.child,
      required this.childWhenPromptComplete,
      this.onPromptComplete})
      : super(key: key);

  void _onPromptComplete() {
    // only call once.
    onPromptComplete?.call();
  }

  void _playPrompt(AudioPrompt audioPrompt) {
    if (!_isPromptPlaying(audioPrompt) && !_isPromptComplete(audioPrompt)) {
      audioPrompt.play(stimulusPairTarget);
    }
  }

  bool _isPromptComplete(AudioPrompt audioPrompt) {
    return audioPrompt.playerState == PlayerState.COMPLETED;
  }

  bool _isPromptPlaying(AudioPrompt audioPrompt) {
    return audioPrompt.playerState == PlayerState.PLAYING;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPrompt>(builder: (context, audioPrompt, _) {
      if (_isPromptComplete(audioPrompt)) {
        _onPromptComplete();
        return childWhenPromptComplete;
      } else {
        _playPrompt(audioPrompt);
        return child;
      }
    });
  }
}
