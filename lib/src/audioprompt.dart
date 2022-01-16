import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:touchtracker/src/stimuli.dart';

class AudioPromptException implements Exception {
  final String message;

  AudioPromptException(this.message);

  @override
  String toString() => message;
}

enum PlaybackState {
  playing,
  completed,
  stopped,
}

class AudioPrompt {
  final player = AudioPlayer();
  static const String assetPath = 'assets/audio/';
  static const String fileExtension = '.wav';
  // getduration fails on web + low_latency. max is 1.5 second, so we use that.
  PlaybackState _playerState = PlaybackState.stopped;
  VoidCallback? _onPlayStart;
  VoidCallback? _onPlayComplete;

  AudioPrompt({VoidCallback? onPlayStart, VoidCallback? onPlayComplete}) {
    // allow for callbacks or statechange listeners
    if (onPlayStart != null) {
      this.onPlayStart = onPlayStart;
    }
    if (onPlayComplete != null) {
      this.onPlayComplete = onPlayComplete;
    }
  }

  Future<void> play(StimulusPairTarget prompt) async {
    if (_playerState == PlaybackState.playing) {
      return Future.error(
          AudioPromptException('AudioPrompt is already playing'));
    }

    String target = prompt.getTargetStimulus();
    String filename = '$assetPath$target$fileExtension';
    // Manually set player state to playing
    stateChangeListener(PlaybackState.playing);

    var duration = await player.setAsset(filename);
    debugPrint("playing $filename for $prompt, duration: $duration");
    await player.play().then((_) {
      player.stop();
      stateChangeListener(PlaybackState.completed);
    });
  }

  void stateChangeListener(PlaybackState state) {
    debugPrint('StateChangeListener: $state');
    if (_playerState == state) {
      debugPrint('no state change, returning');
      return;
    }
    _playerState = state;

    if (state == PlaybackState.playing) {
      _onPlayStart?.call();
    }
    if (state == PlaybackState.completed) {
      _onPlayComplete?.call();
    }
  }

  void resetState() {
    _playerState = PlaybackState.stopped;
  }

  PlaybackState get playerState => _playerState;

  set onPlayStart(VoidCallback callback) {
    _onPlayStart = callback;
  }

  set onPlayComplete(VoidCallback callback) {
    _onPlayComplete = callback;
  }
}
