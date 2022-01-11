import 'package:flutter/foundation.dart';
import 'package:touchtracker/src/storage/experimentstorage.dart';
import 'package:vector_math/vector_math.dart';

/// ExperimentLog is used for keeping a log of pointer tracking data
/// for later writing to a file.
///
///

// Position tracking class
@immutable
class Position {
  final int time;
  late final Vector2 coordinates;

  Position(double x, double y, {required this.time}) {
    coordinates = Vector2(x, y);
  }

  // wrapper for Vector2 distanceTo
  double distance(Position other) {
    return coordinates.distanceTo(other.coordinates);
  }

  // wrapper for Vector2 angleTo
  double angle(Position other) {
    return coordinates.angleTo(other.coordinates);
  }
}

@immutable
class Step {
  late final Position start;
  final Position end;
  late final int duration;
  late final double distance;
  late final double velocity;
  late final double angle;

  Step(this.end, {Position? start}) {
    this.start = start ?? end;
    duration = end.time - this.start.time;
    if (duration < 0) {
      throw Exception('Step cannot end before it starts, sorry.');
    }
    if (duration == 0) {
      distance = 0;
      velocity = 0;
      angle = 0;
    } else {
      distance = end.distance(this.start);
      velocity = distance / duration;
      angle = end.angle(this.start);
    }
  }
}

// kind of linked list but no need for traversal...might change later.
class Movement {
  final List<Step> steps;
  final int time;

  // time is zero by default, but could be a timestamp if we want to
  Movement({Position? startPos, this.time = 0, this.steps = const []}) {
    if (startPos != null) {
      steps.insert(0, Step(startPos));
    }
  }

  void step(Position end) {
    steps.add(Step(end, start: steps.last.end));
  }

  double get distance =>
      steps.fold<double>(0, (sum, step) => sum + step.distance);
  double get distanceAtoB => steps.first.start.distance(steps.last.end);
  double get velocity =>
      steps.fold<double>(0, (sum, step) {
        return sum + step.velocity;
      }) /
      steps.length;

  int get duration => steps.last.end.time - steps.first.start.time;
}

// @TODO: Remove math logic and decouple as much as possible.
// maybe define structure using map?
// fix variable scope (only a few need public).

// requires ExperimentStorage compatible storage backend
class ExperimentLog {
  // top level (experiment)
  String experiment;
  String? subject;
  String? condition;
  DateTime? expStartTime;
  DateTime? expEndTime;
  int? expElapsedTimeMicros;
  ExperimentStorage? storage;

  // trial level
  int trial = 0;
  String? cue;

  DateTime? trialStartTime;
  DateTime? trialEndTime;
  int? trialElapsedTimeMicros;

  double? xStart;
  double? yStart;
  double? xEnd;
  double? yEnd;
  double? avgVel;
  List<double> trialVelocities = [];

  bool? correct;

  // movement level

  double? xPos;
  double? yPos;
  double? stepAngle;
  double? stepDistance;
  double? stepVel;

  // Device
  double? deviceDPI;
  double? deviceViewportWidth;
  double? deviceViewportHeight;
  String? deviceInfo;

  // internal
  final List<List<dynamic>> _logRows = [];
  Stopwatch expStopWatch = Stopwatch();
  Stopwatch trialStopWatch = Stopwatch();
  int logSequence = 0;
  int trialSequence = 0;

  Vector2? posStart;
  Vector2? posEnd;
  Vector2? pos;

  ExperimentLog(this.experiment,
      {this.condition, DateTime? expStartTime, this.subject});

  void _addHeaderRow() {
    List<dynamic> _logRow = [];
    _logRow.add("logSequence");
    _logRow.add("experiment");
    _logRow.add("subject");
    _logRow.add("condition");
    _logRow.add("expStartTime");
    _logRow.add("expEndTime");
    _logRow.add("expElapsedTimeMicros");

    _logRow.add("trial");
    _logRow.add("trialSequence");
    _logRow.add("trialStartTime");
    _logRow.add("trialEndTime");
    _logRow.add("trialElapsedTimeMicros");
    _logRow.add("cue");
    _logRow.add("xStart");
    _logRow.add("yStart");
    _logRow.add("xEnd");
    _logRow.add("yEnd");
    _logRow.add("avgVel");
    _logRow.add("correct");

    _logRow.add("xPos");
    _logRow.add("yPos");
    _logRow.add("stepAngle");
    _logRow.add("setpDistance");
    _logRow.add("stepVel");

    _logRow.add("deviceDPI");
    _logRow.add("deviceVieportWidth");
    _logRow.add("deviceVieportHeight");
    _logRow.add("deviceInfo");

    _logRows.add(_logRow);
  }

  void _addRow() {
    logSequence += 1;
    List<dynamic> _logRow = [];
    _logRow.add(logSequence);
    _logRow.add(experiment);
    _logRow.add(subject);
    _logRow.add(condition);
    _logRow.add(expStartTime);
    _logRow.add(expEndTime);
    _logRow.add(expElapsedTimeMicros);

    _logRow.add(trial);
    _logRow.add(trialSequence);
    _logRow.add(trialStartTime);
    _logRow.add(trialEndTime);
    _logRow.add(trialElapsedTimeMicros);
    _logRow.add(cue);
    _logRow.add(xStart);
    _logRow.add(yStart);
    _logRow.add(xEnd);
    _logRow.add(yEnd);
    _logRow.add(avgVel);
    _logRow.add(correct);

    _logRow.add(xPos);
    _logRow.add(yPos);
    _logRow.add(stepAngle);
    _logRow.add(stepDistance);
    _logRow.add(stepVel);

    _logRow.add(deviceDPI);
    _logRow.add(deviceViewportWidth);
    _logRow.add(deviceViewportHeight);
    _logRow.add(deviceInfo);

    _logRows.add(_logRow);
  }

  // @TODO: Implement
  // ignore: unused_element
  void _trialReset() {
    throw UnimplementedError();
  }

  // @TODO: Implement
  // ignore: unused_element
  void _experimentReset() {
    throw UnimplementedError();
  }

  void startExperiment(ExperimentStorage storage,
      {String? subject, String? condition}) {
    logSequence = 0;
    trial = 0;
    trialVelocities = [];
    this.storage = storage;
    storage.clear();
    if (subject != null) {
      this.subject = subject;
    }
    if (condition != null) {
      this.condition = condition;
    }
    this.storage?.key = experiment + '-' + this.subject!;
    debugPrint("Experiment started");
    expStartTime = expStartTime ?? DateTime.now();
    _addHeaderRow();
    expStopWatch.start();
  }

  void endExperiment() {
    debugPrint("Experiment ended");
    expStopWatch.stop();
    expStopWatch.reset();
    expElapsedTimeMicros = expStopWatch.elapsedMicroseconds;
    expEndTime = DateTime.now();
    addNonTrackingEvent();
    flushLog();
    deviceDPI = null;
    deviceViewportWidth = null;
    deviceViewportHeight = null;
    deviceInfo = null;
  }

  void startTrial({int? trial, String? cue, String? condition}) {
    debugPrint("Trial started");
    trialStartTime = DateTime.now();
    this.cue = cue;
    this.condition = condition;
    trialStopWatch.start();

    this.trial = trial ?? this.trial + 1;
    trialSequence = 0;
  }

  void endTrial() {
    debugPrint("Trial ended");
    trialStopWatch.stop();
    trialEndTime = DateTime.now();
    xEnd = xPos;
    yEnd = yPos;
    addNonTrackingEvent();
    flushLog();
    trialEndTime = null;
    xEnd = null;
    yEnd = null;
    trialSequence = 0;
    condition = null;
    cue = null;

    correct = null;
    trialStopWatch.reset();
  }

  double trialVelocityAverage() {
    int n = trialVelocities.length;

    return n > 0 ? trialVelocities.reduce((a, b) => a + b) / n : 0;
  }

  void addTrackingEvent(Vector2 pos) {
    final int prevStepTime = trialElapsedTimeMicros ?? 0;
    expElapsedTimeMicros = expStopWatch.elapsedMicroseconds;
    trialElapsedTimeMicros = trialStopWatch.elapsedMicroseconds;

    if (trialSequence == 0) {
      posStart = pos;
      xStart = pos.x;
      yStart = pos.y;
      stepAngle = null;
      stepVel = 0.0;
      avgVel = 0.0;
      stepDistance = 0.0;
      trialVelocities = [];
    } else {
      final int stepTime = trialElapsedTimeMicros! - prevStepTime;
      stepAngle = degrees(this.pos!.angleTo(pos));
      stepDistance = this.pos!.distanceTo(pos);
      stepVel = stepDistance! / stepTime;
      trialVelocities.add(stepVel!);
      avgVel = trialVelocityAverage();
    }

    trialSequence += 1;

    this.pos = pos;
    xPos = pos.x;
    yPos = pos.y;

    _addRow();
  }

  void addNonTrackingEvent() {
    stepAngle = null;
    stepVel = 0.0;
    stepDistance = 0.0;
    xStart = xPos;
    yStart = yPos;
    _addRow();
  }

  Future<void> flushLog({bool addHeader = false}) async {
    await storage?.flush(_logRows);
    _logRows.clear();
    if (addHeader) {
      _addHeaderRow();
    }
  }

  Future<void> writeLog() async {
    await storage?.write(_logRows);
  }

  // _logrows getter
  List<List<dynamic>> get logRows => _logRows;
}
