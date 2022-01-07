import 'dart:io';
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
  final bool _onlyNotifyOnComplete = false;
  late final AudioCache audioCache;
  PlayerState _playerState = PlayerState.STOPPED;
  VoidCallback? _onPlayStart;
  VoidCallback? _onPlayComplete;

  AudioPrompt({VoidCallback? onPlayStart, VoidCallback? onPlayComplete}) {
    final PlayerMode mode;
    if (kIsWeb) {
      mode = PlayerMode.MEDIA_PLAYER;
    } else {
      mode = PlayerMode.LOW_LATENCY;
    }
    audioCache = AudioCache(
        fixedPlayer:
            AudioPlayer(mode: mode, playerId: 'TouchTrackerAudioPrompt'));
    if (onPlayStart != null) {
      this.onPlayStart = onPlayStart;
    }
    if (onPlayComplete != null) {
      this.onPlayComplete = onPlayComplete;
    }
    audioCache.fixedPlayer?.onPlayerStateChanged.listen(stateChangeListener);

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService.startHeadlessService();
    }
  }

  AudioPlayer get player => audioCache.fixedPlayer as AudioPlayer;

  Future<AudioPlayer> play(StimulusPairTarget prompt) async {
    if (_playerState == PlayerState.PLAYING) {
      return Future.error(
          AudioPromptException('AudioPrompt is already playing'));
    }
    await Logger.changeLogLevel(LogLevel.INFO);

    String target = prompt.getTargetStimulus();
    String filename = '$assetPath$target$fileExtension';
    debugPrint("playing $filename for $prompt");
    // await audioCache.play(filename);
    // if (!kIsWeb) {
    //   // force rapid state update
    //   stateChangeListener(PlayerState.PLAYING);
    //   return await audioCache.play(filename);
    // }
    debugPrint("web hack");
    // dirty web hack
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    stateChangeListener(PlayerState.PLAYING);
    AudioPlayer player = await audioCache.play(filename);
    int diff = DateTime.now().millisecondsSinceEpoch - currentTime;
    // getduration fails on web. max is 1 second, so we use that.
    const duration = 1000;
    // manually trigger state change
    Future.delayed(Duration(milliseconds: max(duration - diff, 1)), () {
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
      if (!_onlyNotifyOnComplete) {
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
    await audioCache.fixedPlayer?.stop();
    // audioCache.fixedPlayer?.release();
    // notifyListeners();
  }

  PlayerState get playerState => _playerState;

  set onPlayStart(VoidCallback callback) {
    _onPlayStart = callback;
    audioCache.fixedPlayer?.onPlayerStateChanged.listen((state) {});
  }

  set onPlayComplete(VoidCallback callback) {
    _onPlayComplete = callback;
    audioCache.fixedPlayer?.onPlayerStateChanged.listen((state) {
      debugPrint('onPlayerStateChanged (complete callback): $state');
    });
  }
}
