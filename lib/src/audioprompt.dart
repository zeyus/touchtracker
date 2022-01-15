import 'dart:async';

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
  static const String assetPath = 'audio/';
  static const String fileExtension = '.wav';
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
  }

  static AudioCache createAudioCache(
      {String? playerId = 'TouchTrackerAudioPrompt'}) {
    // const PlayerMode mode =
    //    kIsWeb ? PlayerMode.MEDIA_PLAYER : PlayerMode.LOW_LATENCY;
    // return AudioCache(fixedPlayer: AudioPlayer(mode: mode, playerId: playerId));
    return AudioCache();
  }

  static PlayerMode getPlayerMode() {
    return kIsWeb ? PlayerMode.MEDIA_PLAYER : PlayerMode.LOW_LATENCY;
  }

  static Future<void> cacheAssets(AudioCache ac) async {
    await ac.loadAll(Stimuli.stimuli
        .map<String>((String s) => assetPath + s + fileExtension)
        .toList());
  }

  // AudioPlayer get player => audioCache.fixedPlayer as AudioPlayer;

  Future<void> play(StimulusPairTarget prompt) async {
    if (_playerState == PlayerState.PLAYING) {
      return Future.error(
          AudioPromptException('AudioPrompt is already playing'));
    }

    String target = prompt.getTargetStimulus();
    String filename = '$assetPath$target$fileExtension';
    debugPrint("playing $filename for $prompt");
    // dirty web + low_latency hack

    // Manually set player state to playing
    stateChangeListener(PlayerState.PLAYING);
    // just in case
    // await audioCache.fixedPlayer?.stop();

    await audioCache.play(filename, mode: getPlayerMode());

    Future.delayed(const Duration(milliseconds: duration), () async {
      stateChangeListener(PlayerState.COMPLETED);
    });
  }

  // to forward calls from audio player
  void playerStateListener(_) {
    debugPrint("platform called player complete");
    stateChangeListener(PlayerState.COMPLETED);
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
