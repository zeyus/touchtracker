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
  Map<String, AudioSource>? audioSources;
  VoidCallback? _onPlayStart;
  VoidCallback? _onPlayComplete;

  AudioPrompt(
      {this.audioSources,
      VoidCallback? onPlayStart,
      VoidCallback? onPlayComplete}) {
    // allow for callbacks or statechange listeners
    if (onPlayStart != null) {
      this.onPlayStart = onPlayStart;
    }
    if (onPlayComplete != null) {
      this.onPlayComplete = onPlayComplete;
    }
  }

  Future<void> _setPlayerAsset(String target) async {
    String filename = '$assetPath$target$fileExtension';
    await player.setAsset(filename);
  }

  Future<void> play(
      StimulusPairTarget prompt, StimulusPairTarget? preloadNext) async {
    if (_playerState == PlaybackState.playing) {
      return Future.error(
          AudioPromptException('AudioPrompt is already playing'));
    }

    // Manually set player state to playing
    stateChangeListener(PlaybackState.playing);
    String target = prompt.getTargetStimulus();

    debugPrint("playing $target audio for $prompt");

    if (audioSources != null && audioSources!.containsKey(target)) {
      // use preloaded audio source
      if (player.audioSource != audioSources![target]!) {
        debugPrint("no preloaded audio source for $target, loading");
        await player.setAudioSource(audioSources![target]!);
      } else {
        debugPrint("using preloaded audio source for $target");
      }
    } else {
      // load audio from asset
      await _setPlayerAsset(target);
    }

    await player.play().then((_) async {
      await player.pause();
      await player.seek(const Duration(milliseconds: 0));
      stateChangeListener(PlaybackState.completed);
      debugPrint("finishe playing $target audio for $prompt");
      if (preloadNext != null && audioSources != null) {
        target = preloadNext.getTargetStimulus();
        debugPrint("attempting to preload next stimulus $target");
        if (audioSources!.containsKey(target) &&
            player.audioSource != audioSources![target]!) {
          debugPrint("preloading next audio source $target");
          await player.setAudioSource(audioSources![target]!);
        }
      }
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

  void dispose() {
    player.dispose();
  }
}
