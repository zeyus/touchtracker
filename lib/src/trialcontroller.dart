import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart';

class TrialController with ChangeNotifier {
  bool isComplete = false;
  bool isCorrect = false;
  bool stimuliVisible = false;
  double distance = 0.0;
  Vector2 curXY = Vector2(0.0, 0.0);
  double distanceThreshold = 40.0;
  Offset? _startPos;
  late Offset currentPos;

  TrialController({required this.distanceThreshold, Offset? position}) {
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
}
