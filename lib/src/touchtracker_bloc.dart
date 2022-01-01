// all outputs and inputs are streams. no synchronious communication
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'stimuli.dart';
import 'dart:collection';

class TouchTrackerBloc {
  final _targetsSubject =
      BehaviorSubject<UnmodifiableListView<StimulusPairTarget>>();

  final _targets = <StimulusPairTarget>[];

  TouchTrackerBloc() {
    _getTargets().then((_) {
      _targetsSubject.add(UnmodifiableListView(_targets));
    });
  }

  Stream<UnmodifiableListView<StimulusPairTarget>> get targets =>
      _targetsSubject.stream;

  Future<List<StimulusPairTarget>> _getTargets() async {
    return _targets;
  }
}
