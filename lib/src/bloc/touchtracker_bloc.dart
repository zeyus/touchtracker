// all outputs and inputs are streams. no synchronious communication
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'dart:collection';

class TouchTrackerBloc {
  late final Stimuli _stimuli;
  final _targetsSubject =
      BehaviorSubject<UnmodifiableListView<StimulusPairTarget>>();

  var _targets = <StimulusPairTarget>[];

  TouchTrackerBloc({Stimuli? stimuli}) {
    _stimuli = stimuli ?? Stimuli();
    _getTargets().then((_) {
      _targetsSubject.add(UnmodifiableListView(_targets));
    });
  }

  Stream<UnmodifiableListView<StimulusPairTarget>> get targets =>
      _targetsSubject.stream;

  Future<List<StimulusPairTarget>> _getTargets() async {
    _targets = _stimuli.generateExperiment();
    return _targets;
  }

  Stimuli get stimuli => _stimuli;

  void dispose() {
    _targetsSubject.close();
  }
}
