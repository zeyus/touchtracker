import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:touchtracker/src/audioprompt.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:vector_math/vector_math.dart';

class TrialController with ChangeNotifier {
  bool isComplete = false;
  bool isCorrect = false;
  bool stimuliVisible = false;
  bool movementCancelled = false;
  bool trialCompleteCalled = false;
  bool promptStarted = false;
  bool promptComplete = false;
  StimulusPairTarget stimuli;
  StimulusPairTarget? nextStimuli;
  double distance = 0.0;
  Vector2 curXY = Vector2(0.0, 0.0);
  double distanceThreshold = 40.0;
  Offset? _startPos;
  late Offset currentPos;

  TrialController(
      {required this.distanceThreshold,
      required this.stimuli,
      Offset? position,
      this.nextStimuli}) {
    currentPos = position ?? const Offset(0, 0);
    if (distanceThreshold == 0) {
      stimuliVisible = true;
    }
  }

  void completeTrial(bool correct) {
    isComplete = true;
    isCorrect = correct;
    notifyListeners();
  }

  void updateDistance(double x, double y) {
    curXY = Vector2(x, y);
    distance = max((x - startPos.dx).abs(), (y - startPos.dy).abs());
    if (distance > distanceThreshold && !stimuliVisible) {
      stimuliVisible = true;
      notifyListeners();
    }
  }

  void updatePosition(Offset pos) {
    currentPos = pos;
    notifyListeners();
  }

  void updateStartPosition(Offset pos) {
    // only allow once.
    if (_startPos == null) {
      _startPos = pos;
      currentPos = pos;
    }
  }

  Offset get startPos {
    if (_startPos == null) {
      throw Exception('start position not set');
    }
    return _startPos!;
  }

  Vector2 get startXY {
    return Vector2(startPos.dx, startPos.dy);
  }

  void playPrompt(AudioPrompt audioPrompt) {
    if (!promptStarted) {
      promptStarted = true;
      audioPrompt.onPlayComplete = () {
        promptComplete = true;
        Future.delayed(const Duration(milliseconds: 10), () {
          notifyListeners();
        });
      };
      audioPrompt.onPlayStart = () async {
        // forced gross polling behaviour because app sleeps when not in use.
        // this is fucking garbage and probably only needs to be done on android.
        while (!promptComplete) {
          await Future.delayed(const Duration(milliseconds: 25), () {
            notifyListeners();
          });
        }
      };
      audioPrompt.play(stimuli, nextStimuli);
    }
  }
}
