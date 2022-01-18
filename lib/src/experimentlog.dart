import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:touchtracker/src/stimuli.dart';
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

  static Position fromVector2(Vector2 v, {required int time}) {
    return Position(v.x, v.y, time: time);
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
  final List<Step> steps = [];
  final int time;

  // time is zero by default, but could be a timestamp if we want to
  Movement({Position? startPos, this.time = 0}) {
    if (startPos != null) {
      steps.insert(0, Step(startPos));
    }
  }

  void step(Position end) {
    steps.add(Step(end, start: steps.isNotEmpty ? steps.last.end : null));
  }

  double get distance =>
      steps.fold<double>(0, (sum, step) => sum + step.distance);
  double get distanceDirect => steps.first.start.distance(steps.last.end);
  double get velocity =>
      steps.fold<double>(0, (sum, step) {
        return sum + step.velocity;
      }) /
      steps.length;

  int get duration => steps.last.end.time - steps.first.start.time;
  double get angle => steps.last.end.angle(steps.first.start);

  List<double> get velocities => steps.map((step) => step.velocity).toList();
  List<double> get distances => steps.map((step) => step.distance).toList();
  List<double> get angles => steps.map((step) => step.angle).toList();
  List<int> get times => steps.map((step) => step.end.time).toList();

  List<double> get xs => steps.map((step) => step.end.coordinates.x).toList();
  List<double> get ys => steps.map((step) => step.end.coordinates.y).toList();
}

class DataRow {
  int? logSequence;
  DateTime? timestamp;
  String? experiment;
  bool? practice;
  DateTime? experimentStartTime;
  DateTime? experimentEndTime;
  int? experimentElapsedTime;
  String? subjectId;
  int? subjectAge;
  String? subjectGender;
  String? subjectHandedness;
  String? condition;
  String? targetStimulus;
  Target? targetPosition;
  String? nonTargetStimulus;
  Target? nonTargetPosition;
  int? stimulusATimesDisplayed;
  int? stimulusBTimesDisplayed;
  String? trialType;
  String? trialSubtype;
  int? trialSequence;
  DateTime? trialStartTime;
  DateTime? trialEndTime;
  int? trialElapsedTime;
  bool? correct;
  int? responseTime;
  double? responseTimeAverage;
  double? velocityAverage;
  double? distanceStepAverage;
  double? distanceTotal;
  double? distanceDirect;
  double? angleDirect;
  List<int>? timestampsTracking = [];
  List<double>? xposTracking = [];
  List<double>? yposTracking = [];
  List<double>? velocityTracking = [];
  List<double>? distanceTracking = [];
  List<double>? angleTracking = [];
  bool? fullscreen;
  double? viewportWidth;
  double? viewportHeight;
  double? deviceDpi;
  String? deviceInfo;

  static const List<List<String>> colMap = [
    ['logSequence', 'log_sequence'],
    ['timestamp', 'timestamp'],
    ['experiment', 'experiment'],
    ['practice', 'practice'],
    ['experimentStartTime', 'experiment_start_time'],
    ['experimentEndTime', 'experiment_end_time'],
    ['experimentElapsedTime', 'experiment_elapsed_time'],
    ['subjectId', 'subject_id'],
    ['subjectAge', 'subject_age'],
    ['subjectGender', 'subject_gender'],
    ['subjectHandedness', 'subject_handedness'],
    ['condition', 'condition'],
    ['targetStimulus', 'target_stimulus'],
    ['targetPosition', 'target_position'],
    ['nonTargetStimulus', 'non_target_stimulus'],
    ['nonTargetPosition', 'non_target_position'],
    ['stimulusATimesDisplayed', 'stimulus_a_times_displayed'],
    ['stimulusBTimesDisplayed', 'stimulus_b_times_displayed'],
    ['trialType', 'trial_type'],
    ['trialSubtype', 'trial_subtype'],
    ['trialSequence', 'trial_sequence'],
    ['trialStartTime', 'trial_start_time'],
    ['trialEndTime', 'trial_end_time'],
    ['trialElapsedTime', 'trial_elapsed_time'],
    ['correct', 'correct'],
    ['responseTime', 'response_time'],
    ['responseTimeAverage', 'response_time_average'],
    ['velocityAverage', 'velocity_average'],
    ['distanceStepAverage', 'distance_step_average'],
    ['distanceTotal', 'distance_total'],
    ['distanceDirect', 'distance_direct'],
    ['angleDirect', 'angle_direct'],
    ['timestampsTracking', 'timestamps_tracking'],
    ['xposTracking', 'xpos_tracking'],
    ['yposTracking', 'ypos_tracking'],
    ['velocityTracking', 'velocity_tracking'],
    ['distanceTracking', 'distance_tracking'],
    ['angleTracking', 'angle_tracking'],
    ['fullscreen', 'fullscreen'],
    ['viewportWidth', 'viewport_width'],
    ['viewportHeight', 'viewport_height'],
    ['deviceDpi', 'device_dpi'],
    ['deviceInfo', 'device_info'],
  ];

  static DataRow fromDataRow(DataRow dr) {
    return DataRow()
      ..logSequence = dr.logSequence
      ..timestamp = dr.timestamp
      ..experiment = dr.experiment
      ..practice = dr.practice
      ..experimentStartTime = dr.experimentStartTime
      ..experimentEndTime = dr.experimentEndTime
      ..experimentElapsedTime = dr.experimentElapsedTime
      ..subjectId = dr.subjectId
      ..subjectAge = dr.subjectAge
      ..subjectGender = dr.subjectGender
      ..subjectHandedness = dr.subjectHandedness
      ..condition = dr.condition
      ..targetStimulus = dr.targetStimulus
      ..targetPosition = dr.targetPosition
      ..nonTargetStimulus = dr.nonTargetStimulus
      ..nonTargetPosition = dr.nonTargetPosition
      ..stimulusATimesDisplayed = dr.stimulusATimesDisplayed
      ..stimulusBTimesDisplayed = dr.stimulusBTimesDisplayed
      ..trialType = dr.trialType
      ..trialSubtype = dr.trialSubtype
      ..trialSequence = dr.trialSequence
      ..trialStartTime = dr.trialStartTime
      ..trialEndTime = dr.trialEndTime
      ..trialElapsedTime = dr.trialElapsedTime
      ..correct = dr.correct
      ..responseTime = dr.responseTime
      ..responseTimeAverage = dr.responseTimeAverage
      ..velocityAverage = dr.velocityAverage
      ..distanceStepAverage = dr.distanceStepAverage
      ..distanceTotal = dr.distanceTotal
      ..distanceDirect = dr.distanceDirect
      ..angleDirect = dr.angleDirect
      ..timestampsTracking = dr.timestampsTracking
      ..xposTracking = dr.xposTracking
      ..yposTracking = dr.yposTracking
      ..velocityTracking = dr.velocityTracking
      ..distanceTracking = dr.distanceTracking
      ..angleTracking = dr.angleTracking
      ..fullscreen = dr.fullscreen
      ..viewportWidth = dr.viewportWidth
      ..viewportHeight = dr.viewportHeight
      ..deviceDpi = dr.deviceDpi
      ..deviceInfo = dr.deviceInfo;
  }

  static List<String> get colNames => colMap.map((col) => col[1]).toList();

  List<String?> get colValues => colMap.map((col) => getValue(col[0])).toList();

  String? getValue(String col) {
    switch (col) {
      case 'logSequence':
        return logSequence.toString();
      case 'timestamp':
        return timestamp.toString();
      case 'experiment':
        return experiment;
      case 'practice':
        return practice.toString();
      case 'experimentStartTime':
        return experimentStartTime?.toIso8601String();
      case 'experimentEndTime':
        return experimentEndTime?.toIso8601String();
      case 'experimentElapsedTime':
        return experimentElapsedTime.toString();
      case 'subjectId':
        return subjectId;
      case 'subjectAge':
        return subjectAge.toString();
      case 'subjectGender':
        return subjectGender;
      case 'subjectHandedness':
        return subjectHandedness;
      case 'condition':
        return condition;
      case 'targetStimulus':
        return targetStimulus;
      case 'targetPosition':
        return targetPosition.toString();
      case 'nonTargetStimulus':
        return nonTargetStimulus;
      case 'nonTargetPosition':
        return nonTargetPosition.toString();
      case 'stimulusATimesDisplayed':
        return stimulusATimesDisplayed.toString();
      case 'stimulusBTimesDisplayed':
        return stimulusBTimesDisplayed.toString();
      case 'trialType':
        return trialType;
      case 'trialSubtype':
        return trialSubtype;
      case 'trialSequence':
        return trialSequence.toString();
      case 'trialStartTime':
        return trialStartTime.toString();
      case 'trialEndTime':
        return trialEndTime.toString();
      case 'trialElapsedTime':
        return trialElapsedTime.toString();
      case 'correct':
        return correct.toString();
      case 'responseTime':
        return responseTime.toString();
      case 'responseTimeAverage':
        return responseTimeAverage.toString();
      case 'velocityAverage':
        return velocityAverage.toString();
      case 'distanceStepAverage':
        return distanceStepAverage.toString();
      case 'distanceTotal':
        return distanceTotal.toString();
      case 'distanceDirect':
        return distanceDirect.toString();
      case 'angleDirect':
        return angleDirect.toString();
      case 'timestampsTracking':
        // output to miliseconds
        return timestampsTracking?.map((e) => (e / 1000).toString()).join(',');
      case 'xposTracking':
        return xposTracking.toString();
      case 'yposTracking':
        return yposTracking.toString();
      case 'velocityTracking':
        return velocityTracking.toString();
      case 'distanceTracking':
        return distanceTracking.toString();
      case 'angleTracking':
        return angleTracking.toString();
      case 'fullscreen':
        return fullscreen.toString();
      case 'viewportWidth':
        return viewportWidth.toString();
      case 'viewportHeight':
        return viewportHeight.toString();
      case 'deviceDpi':
        return deviceDpi.toString();
      case 'deviceInfo':
        return deviceInfo;
      default:
        throw Exception('Unknown column name: $col');
    }
  }
}

class DataLog {
  final DataRow _template = DataRow();
  DataRow? _trialTemplate;
  final List<DataRow> _data = [];
  final Stopwatch _experimentTimer = Stopwatch();
  final Stopwatch _trialTimer = Stopwatch();
  Movement? _trialSteps;

  void add(DataRow dr) {
    _data.add(dr);
  }

  set deviceInfo(String deviceInfo) {
    _template.deviceInfo = deviceInfo;
  }

  void start(String experimentId, String subjectId, String condition,
      {int? subjectAge, String? subjectGender, String? subjectHandedness}) {
    _data.clear();
    _template
      ..experiment = experimentId
      ..timestamp = DateTime.now()
      ..subjectId = subjectId
      ..subjectAge = subjectAge
      ..subjectGender = subjectGender
      ..subjectHandedness = subjectHandedness
      ..condition = condition
      ..logSequence = 0
      ..experimentElapsedTime = 0
      ..experimentStartTime = DateTime.now();
    _experimentTimer.reset();
    _experimentTimer.start();
  }

  void trialStart({required StimulusPairTarget stimuli}) {
    _trialTemplate = DataRow.fromDataRow(_template);
    _trialTemplate!
      ..timestamp = DateTime.now()
      ..trialType = PairTypeExtension.getType(stimuli.pairType)
      ..trialSubtype = PairTypeExtension.getSubType(stimuli.pairType)
      ..trialSequence = 0
      ..trialElapsedTime = 0
      ..trialStartTime = DateTime.now()
      ..targetStimulus = stimuli.getTargetStimulus()
      ..targetPosition = stimuli.target
      ..nonTargetStimulus = stimuli.getCompetitorStimulus()
      ..nonTargetPosition = stimuli.competitor;
    _trialSteps = Movement();
    _trialTimer.reset();
    _trialTimer.start();
  }

  void move(Vector2 pos) {
    _trialSteps!
        .step(Position.fromVector2(pos, time: _trialTimer.elapsedMicroseconds));
  }

  DataRow trialEnd(bool correct) {
    if (_trialTemplate == null) {
      debugPrint("Error: Trial end called before trial start");
      return DataRow.fromDataRow(_template);
    }
    _trialTemplate!
      ..timestamp = DateTime.now()
      ..trialEndTime = DateTime.now()
      ..trialElapsedTime = _trialTimer.elapsedMilliseconds
      ..experimentElapsedTime = _experimentTimer.elapsedMilliseconds
      ..correct = correct;
    _trialTimer.stop();

    final dr = DataRow.fromDataRow(_trialTemplate!);
    dr
      ..velocityAverage = _trialSteps!.velocity
      ..distanceTotal = _trialSteps!.distance
      ..distanceDirect = _trialSteps!.distanceDirect
      ..angleDirect = _trialSteps!.angle
      ..timestampsTracking = _trialSteps!.times
      ..xposTracking = _trialSteps!.xs
      ..yposTracking = _trialSteps!.ys
      ..velocityTracking = _trialSteps!.velocities
      ..distanceTracking = _trialSteps!.distances
      ..angleTracking = _trialSteps!.angles
      ..responseTime = _trialSteps!.duration;

    add(dr);
    return dr;
  }

  void end() {
    _template
      ..timestamp = DateTime.now()
      ..experimentEndTime = DateTime.now()
      ..experimentElapsedTime = _experimentTimer.elapsedMilliseconds;
    _experimentTimer.stop();
    int counter = 0;
    int responseTimes = 0;
    for (var row in _data) {
      responseTimes += row.responseTime ?? 0;
      row
        ..logSequence = counter
        ..experimentEndTime = _template.experimentEndTime
        ..responseTimeAverage = responseTimes / counter + 1;
      counter++;
    }
  }

  void displayDetails(
      {required double w,
      required double h,
      required double dpi,
      bool fullscreen = false}) {
    _template
      ..fullscreen = fullscreen
      ..viewportWidth = w
      ..viewportHeight = h
      ..deviceDpi = dpi;
    _trialTemplate
      ?..fullscreen = fullscreen
      ..viewportWidth = w
      ..viewportHeight = h
      ..deviceDpi = dpi;
  }

  List<List<String?>> get data {
    final rows = <List<String?>>[];
    for (var row in _data) {
      rows.add(row.colValues);
    }
    return rows;
  }
}

class ExperimentLog {
  final ExperimentStorage storage;
  final String experimentId;
  final _dataLog = DataLog();
  static const bool _saveOnTrack = false;
  static const bool _rateLimit = false;
  static const int _sampleRateMs = 5;
  final Stopwatch _rateLimiter = Stopwatch();
  int _debugLoggedSamples = 0;
  int _debugDroppedSamples = 0;
  String subjectId = '';
  int? subjectAge;
  String? subjectGender;
  String? subjectHandedness;
  String condition = '';
  ExperimentLog({required this.storage, required this.experimentId});

  String get storageKey {
    return '$experimentId-$subjectId-$condition';
  }

  void start() {
    if (_rateLimit) {
      if (kDebugMode) {
        _debugLoggedSamples = 0;
        _debugDroppedSamples = 0;
      }
      _rateLimiter.reset();
      _rateLimiter.start();
    }
    storage.clear();
    if (_saveOnTrack) {
      _writeHeader();
    }

    _dataLog.start(experimentId, subjectId, condition,
        subjectAge: subjectAge,
        subjectGender: subjectGender,
        subjectHandedness: subjectHandedness);

    // get device information from plugin
    final deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfoPlugin.deviceInfo.then((value) {
      _dataLog.deviceInfo = value.toMap().toString();
    });
  }

  void _write(List<String?> data) {
    storage.flush([data], key: storageKey);
  }

  void _writeAll(List<List<String?>> data) {
    data.insert(0, _header);
    storage.flush(data, key: storageKey);
  }

  void _writeRow(DataRow dr) {
    _write(dr.colValues);
  }

  void _writeHeader() {
    _write(_header);
  }

  List<String> get _header {
    return DataRow.colNames;
  }

  void displayDetails(
      {required double w,
      required double h,
      required double dpi,
      bool fullscreen = false}) {
    _dataLog.displayDetails(w: w, h: h, dpi: dpi, fullscreen: fullscreen);
  }

  void track(Vector2 pos) {
    if (_rateLimit && _rateLimiter.elapsedMilliseconds < _sampleRateMs) {
      if (kDebugMode) {
        _debugDroppedSamples++;
      }
      return;
    } else if (_rateLimit) {
      if (kDebugMode) {
        _debugLoggedSamples++;
      }
      _rateLimiter.reset();
      _rateLimiter.start();
    }
    _dataLog.move(pos);
  }

  void trialStart(StimulusPairTarget stimuli) {
    _dataLog.trialStart(stimuli: stimuli);
  }

  void trialEnd({bool correct = false}) {
    DataRow dr = _dataLog.trialEnd(correct);
    if (_saveOnTrack) {
      _writeRow(dr);
    }
    if (kDebugMode) {
      print(
          'logged $_debugLoggedSamples samples, dropped $_debugDroppedSamples');
    }
  }

  void end() {
    _dataLog.end();
    if (!_saveOnTrack) {
      _writeAll(_dataLog.data);
    }
  }
}
