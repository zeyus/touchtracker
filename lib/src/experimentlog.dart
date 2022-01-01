import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart';

// "acc","accuracy","average_response_time","avg_rt","background","bidi",
// "canvas_backend","clock_backend","color_backend","compensation","coordinates",
// "correct","correct_button_mousetrap_response","correct_instructions",
// "correct_mousetrap_response","correct_response","count_block_loop",
// "count_block_sequence","count_cue","count_end_of_experiment","count_experiment",
// "count_experimental_loop","count_fixation","count_instructions","count_logger",
// "count_mousetrap_response","count_reset_feedback","count_stimuli",
// "count_trial_sequence","cue","datetime","description",
// "disable_garbage_collection","experiment_file","experiment_path",
// "font_bold","font_family","font_italic","font_size","font_underline",
// "foreground","form_clicks","fullscreen","height","initiation_time",
// "initiation_time_mousetrap_response","keyboard_backend","left_letter",
// "live_row","live_row_block_loop","live_row_experimental_loop","logfile",
// "mouse_backend","opensesame_codename","opensesame_version","practice",
// "repeat_cycle","response","response_end_of_experiment","response_instructions",
// "response_mousetrap_response","response_time","response_time_end_of_experiment",
// "response_time_instructions","response_time_mousetrap_response","right_letter",
// "round_decimals","sampler_backend","sound_buf_size","sound_channels","sound_freq",
// "sound_sample_size","start","subject_nr","subject_parity","time_block_loop",
// "time_block_sequence","time_cue","time_end_of_experiment","time_experiment",
// "time_experimental_loop","time_fixation","time_instructions","time_logger",
// "time_mousetrap_response","time_reset_feedback","time_stimuli",
// "time_trial_sequence","timestamps_mousetrap_response","title",
// "total_correct","total_response_time","total_responses","trial_type",
// "uniform_coordinates","width","xpos_mousetrap_response",
// "ypos_mousetrap_response"

/// ExperimentLog is used for keeping a log of pointer tracking data
/// for later writing to a file.
class ExperimentLog {
  // top level (experiment)
  String experiment;
  String subject;
  String? condition;
  DateTime? expStartTime;
  DateTime? expEndTime;
  int? expElapsedTimeMicros;

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

  bool? correct;

  // movement level

  double? xPos;
  double? yPos;
  double? stepAngle;
  double? stepDistance;
  double? stepVel;

  // internal
  final List<List<dynamic>> _logRows = [];
  Stopwatch expStopWatch = Stopwatch();
  Stopwatch trialStopWatch = Stopwatch();
  int logSequence = 0;
  int trialSequence = 0;

  Vector2? posStart;
  Vector2? posEnd;
  Vector2? pos;

  ExperimentLog(this.experiment, this.subject,
      {this.condition, DateTime? expStartTime}) {
    this.expStartTime = expStartTime ?? DateTime.now();
    _addHeaderRow();
  }

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

    _logRows.add(_logRow);
  }

  void startExperiment() {
    expStopWatch.start();
  }

  void endExperiment() {
    expStopWatch.stop();
    expStopWatch.reset();
  }

  void startTrial({int? trial}) {
    trialStartTime = DateTime.now();
    trialStopWatch.start();

    this.trial = trial ?? this.trial + 1;
    trialSequence = 0;
  }

  void endTrial() {
    trialStopWatch.stop();
    trialStopWatch.reset();
  }

  void addTrackingEvent(Vector2 pos) {
    final int prevStepTime = trialElapsedTimeMicros ?? 0;
    expElapsedTimeMicros = expStopWatch.elapsedMicroseconds;
    trialElapsedTimeMicros = trialStopWatch.elapsedMicroseconds;

    if (trialSequence == 0) {
      posStart = pos;
      xStart = xPos;
      yStart = yPos;
      stepAngle = null;
      stepVel = 0.0;
      stepDistance = 0.0;
    } else {
      final int stepTime = trialElapsedTimeMicros! - prevStepTime;
      stepAngle = degrees(this.pos!.angleTo(pos));
      stepDistance = this.pos!.distanceTo(pos);
      stepVel = stepDistance! / stepTime;
    }

    trialSequence += 1;

    this.pos = pos;
    xPos = pos.x;
    yPos = pos.y;

    _addRow();
  }

  void debugLog() {
    if (kDebugMode) {
      print(_logRows.toString());
    }
  }

  // _logrows getter
  List<List<dynamic>> get logRows => _logRows;
}
