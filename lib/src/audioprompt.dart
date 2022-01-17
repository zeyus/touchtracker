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
  final player = AudioPlayer(
      handleInterruptions: false,
      audioLoadConfiguration: AudioLoadConfiguration(
          androidLoadControl: AndroidLoadControl(
        minBufferDuration: const Duration(milliseconds: 1),
        maxBufferDuration: const Duration(seconds: 80),
        bufferForPlaybackDuration: const Duration(milliseconds: 1),
        bufferForPlaybackAfterRebufferDuration: const Duration(milliseconds: 1),
        targetBufferBytes: 200000,
      )));
  static const String assetPath = 'assets/audio/';
  static const String fileExtension = '.wav';
  static ConcatenatingAudioSource? _experimentPlaylist;
  bool _playlistLoaded = false;
  // getduration fails on web + low_latency. max is 1.5 second, so we use that.
  PlaybackState _playerState = PlaybackState.stopped;
  List<AudioSource>? audioSources;
  VoidCallback? _onPlayStart;
  VoidCallback? _onPlayComplete;
  int _currentIndex = -1;

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
    // if (audioSource != null) {
    //   player.setAudioSource(audioSource!);
    // }
    player.setLoopMode(LoopMode.off);
  }

  void updateExperimentPlaylist(List<StimulusPairTarget> pairs) {
    List<AudioSource> playlistItems = [];
    for (var pair in pairs) {
      playlistItems.add(
          audioSources![Stimuli.stimuli.indexOf(pair.getTargetStimulus())]);
    }
    _experimentPlaylist = ConcatenatingAudioSource(
        children: playlistItems, useLazyPreparation: false);
  }

  void createExperimentPlaylistIfNull(List<StimulusPairTarget> pairs) {
    if (_experimentPlaylist == null) {
      updateExperimentPlaylist(pairs);
    }
  }

  Future<void> loadExperiment(List<StimulusPairTarget> pairs) async {
    // @TODO: play a blank file to prepare the audio system
    createExperimentPlaylistIfNull(pairs);
    if (!_playlistLoaded) {
      await player.setAudioSource(_experimentPlaylist!);
      _playlistLoaded = true;

      player.playbackEventStream.listen((event) async {
        if (_playerState == PlaybackState.playing &&
            event.processingState == ProcessingState.completed) {
          if (event.updatePosition >= event.duration!) {
            stateChangeListener(PlaybackState.completed);
            Future.delayed(const Duration(milliseconds: 200), () async {
              debugPrint("Pausing playback...");
              await player.pause();
              debugPrint("Moving item ${event.currentIndex} to $_currentIndex");
              await _experimentPlaylist!
                  .move(event.currentIndex!, _currentIndex);
            });
          }
        }
      });
    }
  }

  set currentIndex(int index) {
    _currentIndex = index;
  }

  // Future<void> _setPlayerAsset(String target) async {
  //   String filename = '$assetPath$target$fileExtension';
  //   await player.setAsset(filename);
  // }

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
    while (!_playlistLoaded) {
      // just in case the playlist isn't loaded yet
      await Future.delayed(const Duration(milliseconds: 100));
    }
    int lastIndex = _experimentPlaylist!.length - 1;
    await _experimentPlaylist!.move(_currentIndex, lastIndex).then((_) async {
      debugPrint(
          "moved $target (index: $_currentIndex) to end of playlist (index: $lastIndex)");
      if (player.currentIndex != lastIndex) {
        await player.seek(Duration.zero, index: lastIndex);
        debugPrint("Player seek to $lastIndex");
      }

      player.play();
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
