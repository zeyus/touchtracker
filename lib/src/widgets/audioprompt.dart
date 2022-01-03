import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:touchtracker/src/stimuli.dart';

class AudioPrompt {
  final String assetPath = 'audio/';
  final String fileExtension = '.wav';
  late final AudioCache audioCache;
  VoidCallback? onPlayStart;
  VoidCallback? onPlayComplete;

  AudioPrompt({Key? key, this.onPlayStart, this.onPlayComplete}) {
    audioCache = AudioCache(fixedPlayer: AudioPlayer());
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
        Duration(milliseconds: max(duration - diff, 1)), onPlayComplete);
  }

  void setOnPlayStart(VoidCallback callback) {
    onPlayStart = callback;
    audioCache.fixedPlayer?.onPlayerStateChanged.listen((state) {
      debugPrint('onPlayerStateChanged (play callback): $state');
      if (state == PlayerState.PLAYING) {
        callback();
      }
    });
  }

  void setOnPlayComplete(VoidCallback callback) {
    onPlayComplete = callback;
    audioCache.fixedPlayer?.onPlayerStateChanged.listen((state) {
      debugPrint('onPlayerStateChanged (complete callback): $state');
      if (state == PlayerState.STOPPED || state == PlayerState.COMPLETED) {
        callback();
      }
    });
  }
}
