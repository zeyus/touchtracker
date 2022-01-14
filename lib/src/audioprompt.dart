import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:touchtracker/src/stimuli.dart';

class AudioPromptException implements Exception {
  final String message;

  AudioPromptException(this.message);

  @override
  String toString() => message;
}

class AudioPrompt with ChangeNotifier {
  final String assetPath = 'audio/';
  final String fileExtension = '.wav';
  // getduration fails on web + low_latency. max is 1.5 second, so we use that.
  static const duration = 1250;
  late final bool onlyNotifyOnComplete;
  late final AudioCache audioCache;
  late final String _playerId;
  PlayerState _playerState = PlayerState.STOPPED;
  VoidCallback? _onPlayStart;
  VoidCallback? _onPlayComplete;

  AudioPrompt(
      {VoidCallback? onPlayStart,
      VoidCallback? onPlayComplete,
      AudioCache? existingAudioCache,
      String? playerId,
      this.onlyNotifyOnComplete = false}) {
    _playerId = playerId ?? 'TouchTrackerAudioPrompt';

    // reuse if possible
    audioCache = existingAudioCache ?? createAudioCache(playerId: _playerId);

    // allow for callbacks or statechange listeners
    if (onPlayStart != null) {
      this.onPlayStart = onPlayStart;
    }
    if (onPlayComplete != null) {
      this.onPlayComplete = onPlayComplete;
    }
    // if we get a working state listener, we can use it to notify the user
    // but for now, we need to manually handle it with a future // timer.
    //audioCache.fixedPlayer?.onPlayerStateChanged.listen(stateChangeListener);
  }

  static AudioCache createAudioCache(
      {String? playerId = 'TouchTrackerAudioPrompt'}) {
    final PlayerMode mode;
    if (kIsWeb) {
      mode = PlayerMode.MEDIA_PLAYER;
    } else {
      mode = PlayerMode.LOW_LATENCY;
    }
    return AudioCache(fixedPlayer: AudioPlayer(mode: mode, playerId: playerId));
  }

  AudioPlayer get player => audioCache.fixedPlayer as AudioPlayer;

  Future<AudioPlayer> play(StimulusPairTarget prompt) async {
    if (_playerState == PlayerState.PLAYING) {
      return Future.error(
          AudioPromptException('AudioPrompt is already playing'));
    }

    String target = prompt.getTargetStimulus();
    String filename = '$assetPath$target$fileExtension';
    debugPrint("playing $filename for $prompt");
    // dirty web + low_latency hack
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    // Manually set player state to playing
    stateChangeListener(PlayerState.PLAYING);

    AudioPlayer player = await audioCache.play(filename);
    int diff = DateTime.now().millisecondsSinceEpoch - currentTime;

    // manually trigger state change
    Future.delayed(Duration(milliseconds: max(duration - diff, 1)), () async {
      // just in case...
      await audioCache.fixedPlayer?.stop();
      stateChangeListener(PlayerState.COMPLETED);
    });
    return player;
  }

  void stateChangeListener(PlayerState state) {
    debugPrint('StateChangeListener: $state');
    if (_playerState == state) {
      debugPrint('no state change, returning');
      return;
    }
    _playerState = state;

    if (state == PlayerState.PLAYING) {
      _onPlayStart?.call();
      if (!onlyNotifyOnComplete) {
        notifyListeners();
      }
    }
    if (state == PlayerState.COMPLETED) {
      _onPlayComplete?.call();
      debugPrint("notify listeners");
      notifyListeners();
    }
  }

  Future<void> resetState() async {
    _playerState = PlayerState.STOPPED;

    // audioCache.fixedPlayer?.release();
    // notifyListeners();
  }

  PlayerState get playerState => _playerState;

  set onPlayStart(VoidCallback callback) {
    _onPlayStart = callback;
    // audioCache.fixedPlayer?.onPlayerStateChanged.listen((state) {});
  }

  set onPlayComplete(VoidCallback callback) {
    _onPlayComplete = callback;
    // audioCache.fixedPlayer?.onPlayerStateChanged.listen((state) {
    //   debugPrint('onPlayerStateChanged (complete callback): $state');
    // });
  }
}
