// Main widget for audio player only
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchtracker/src/audioprompt.dart';
import 'package:touchtracker/src/stimuli.dart';

class AudioCue extends StatelessWidget {
  final AudioCache audioCache;
  final StimulusPairTarget stimulusPairTarget;
  final Widget child;
  final Widget childWhenPromptComplete;
  final Function? onPromptComplete;
  late final AudioPrompt audioPrompt;

  AudioCue(
      {Key? key,
      required this.audioCache,
      required this.stimulusPairTarget,
      required this.child,
      required this.childWhenPromptComplete,
      this.onPromptComplete})
      : super(key: key) {
    audioPrompt =
        AudioPrompt(existingAudioCache: audioCache, onlyNotifyOnComplete: true);
  }

  void _onPromptComplete() {
    // only call once.
    onPromptComplete?.call();
  }

  void _playPrompt() {
    if (!_isPromptPlaying() && !_isPromptComplete()) {
      audioPrompt.play(stimulusPairTarget);
    }
  }

  bool _isPromptComplete() {
    return audioPrompt.playerState == PlayerState.COMPLETED;
  }

  bool _isPromptPlaying() {
    return audioPrompt.playerState == PlayerState.PLAYING;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AudioPrompt>.value(
        value: audioPrompt,
        child: Consumer<AudioPrompt>(builder: (context, _audioPrompt, _) {
          if (_isPromptComplete()) {
            _onPromptComplete();
            return childWhenPromptComplete;
          } else {
            _playPrompt();
            return child;
          }
        }));
  }
}
