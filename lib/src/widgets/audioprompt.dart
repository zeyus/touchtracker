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
    return await audioCache.play(filename);
  }

  // maybe keep for future implementation for web
  Future<void> playHack(StimulusPairTarget prompt) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    AudioPlayer player = await play(prompt);
    int diff = DateTime.now().millisecondsSinceEpoch - currentTime;
    int duration = await player.getDuration();
    debugPrint("$diff vs $duration");
    Future.delayed(
        Duration(milliseconds: max(duration - diff, 1)), _onPlayComplete);
  }

  void stateChangeListener(PlayerState state) {
    _playerState = state;
    debugPrint('StateChangeListener: $state');
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
