import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:touchtracker/src/stimuli.dart';

class AudioPrompt with ChangeNotifier {
  final String assetPath = 'audio/';
  final String fileExtension = '.wav';
  final bool _onlyNotifyOnComplete = true;
  late final AudioCache audioCache;
  PlayerState _playerState = PlayerState.STOPPED;
  VoidCallback? _onPlayStart;
  VoidCallback? _onPlayComplete;

  AudioPrompt({VoidCallback? onPlayStart, VoidCallback? onPlayComplete}) {
    audioCache = AudioCache(fixedPlayer: AudioPlayer());
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

  Future<AudioPlayer> play(StimulusPairTarget prompt) async {
    String target = prompt.getTargetStimulus();
    String filename = '$assetPath$target$fileExtension';
    debugPrint("playing $filename for $prompt");
    // await audioCache.play(filename);
    if (!kIsWeb) {
      return await audioCache.play(filename);
    }
    debugPrint("web hack");
    // dirty web hack
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    AudioPlayer player = await audioCache.play(filename);
    int diff = DateTime.now().millisecondsSinceEpoch - currentTime;
    // getduration fails on web. max is 1 second, so we use that.
    const duration = 1000;
    // manually trigger state change
    Future.delayed(Duration(milliseconds: max(duration - diff, 1)), () {
      if (_playerState != PlayerState.COMPLETED) {
        stateChangeListener(PlayerState.COMPLETED);
      }
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

  void resetState() {
    _playerState = PlayerState.STOPPED;
    audioCache.fixedPlayer?.stop();
    notifyListeners();
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
