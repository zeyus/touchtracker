import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';

// enum of target a or b
enum Target { a, b }

enum PairType { control, phonoCompetitor, phonoTarget }

// add extension to Target to get random target
extension TargetExtension on Target {
  static Target getRandom() {
    var random = Random().nextInt(2);
    return Target.values[random];
  }
}

class StimulusPair<T1, T2> {
  final T1 a;
  final T2 b;

  StimulusPair(this.a, this.b);

  bool isA(T1 value) => a == value;
  bool isB(T2 value) => b == value;
  bool isMember(T1 value) => a == value || b == value;
  bool hasSharedMember(StimulusPair other) =>
      isMember(other.a) || isMember(other.b);
  getFromTarget(Target t) => t == Target.a ? a : b;
  getCompetitorFromTarget(Target t) => t == Target.a ? b : a;

  // string representation of the pair
  @override
  String toString() => '($a, $b)';

  // override equality operator to ignore order
  @override
  bool operator ==(Object other) =>
      other is StimulusPair &&
      (a == other.a && b == other.b || a == other.b && b == other.a);

  // implement hashcode to ignore order
  @override
  int get hashCode => a.hashCode ^ b.hashCode;
}

// StimulusPairTarget is a StimulusPair with a target and pairtype
class StimulusPairTarget<T1, T2> extends StimulusPair<T1, T2> {
  final Target _target;
  final PairType _pairType;

  StimulusPairTarget(T1 a, T2 b, this._target, this._pairType) : super(a, b);

  // static method to create a StimulusPairTarget from a StimulusPair
  static StimulusPairTarget<T1, T2> fromStimulusPair<T1, T2>(
      StimulusPair<T1, T2> pair, Target target, PairType pairType) {
    return StimulusPairTarget(pair.a, pair.b, target, pairType);
  }

  getTargetStimulus() => getFromTarget(_target);
  getCompetitorStimulus() => getCompetitorFromTarget(_target);

  // getters
  Target get target => _target;
  PairType get pairType => _pairType;
}

class Stimuli {
  final Map<String, String> _assetNames = {
    'ball': 'assets/vector/ball.svg',
    'barrel': 'assets/vector/barrel.svg',
    'boar': 'assets/vector/boar.svg',
    'candle': 'assets/vector/candle.svg',
    'candy': 'assets/vector/candy.svg',
    'cloud': 'assets/vector/cloud.svg',
    'clown': 'assets/vector/clown.svg',
    'fish': 'assets/vector/fish.svg',
    'fist': 'assets/vector/fist.svg',
    'microphone': 'assets/vector/microphone.svg',
    'microscope': 'assets/vector/microscope.svg',
    'moon': 'assets/vector/moon.svg',
    'mouse': 'assets/vector/mouse.svg',
    'mouth': 'assets/vector/mouth.svg',
    'pear': 'assets/vector/pear.svg',
    'road': 'assets/vector/road.svg',
    'robe': 'assets/vector/robe.svg',
    'sheep': 'assets/vector/sheep.svg',
    'ship': 'assets/vector/ship.svg',
    'shoe': 'assets/vector/shoe.svg',
    'skate': 'assets/vector/skate.svg',
    'snake': 'assets/vector/snake.svg',
    'spoon': 'assets/vector/spoon.svg',
    'track': 'assets/vector/track.svg',
    'truck': 'assets/vector/truck.svg',
  };
  final List<StimulusPair> _phonologicalPairs = [
    StimulusPair('ball', 'boar'),
    StimulusPair('candy', 'candle'),
    StimulusPair('cloud', 'clown'),
    StimulusPair('fish', 'fist'),
    StimulusPair('microphone', 'microscope'),
    StimulusPair('mouse', 'mouth'),
    StimulusPair('road', 'robe'),
    StimulusPair('sheep', 'ship'),
    StimulusPair('skate', 'snake'),
    StimulusPair('track', 'truck'),
  ];

  final List<String> _allStimuli = [];

  final Map<String, Widget> _preparedAssets = {};

  Stimuli() {
    _allStimuli.addAll(_assetNames.keys);
  }

  Widget stimulus(String name) {
    if (_preparedAssets.containsKey(name)) {
      return _preparedAssets[name]!;
    }
    if (_assetNames.containsKey(name)) {
      final String? assetPath = _assetNames[name];
      _preparedAssets[name] = SvgPicture.asset(assetPath!);
      return SvgPicture.asset(assetPath);
    } else {
      throw Exception('No such stimulus: $name');
    }
  }

  List<StimulusPairTarget> generatePhonologicalPairs(StimulusPair pair,
      {Target targetSrc = Target.a, nPre = 3, Target targetDst = Target.a}) {
    // result pairs
    final List<StimulusPairTarget> result = [];
    // exclude target and competitor from list of all stimuli
    final List<String> nonCompetitorStimuli =
        _allStimuli.where((String s) => s != pair.a && s != pair.b).toList();

    final String targetStim = pair.getFromTarget(targetSrc);
    final String competitor = pair.getCompetitorFromTarget(targetSrc);
    // shuffle stimuli
    nonCompetitorStimuli.shuffle();
    // generate 3 pairs with target and non competitor
    for (int i = 0; i < nPre; i++) {
      // get competitor from list of stimuli and remove it from list
      final String nonCompetitor = nonCompetitorStimuli.removeLast();
      if (targetDst == Target.a) {
        result.add(StimulusPairTarget(
            nonCompetitor, competitor, Target.b, PairType.phonoCompetitor));
      } else {
        result.add(StimulusPairTarget(
            competitor, nonCompetitor, Target.a, PairType.phonoCompetitor));
      }
    }
    // finally add target b and random non competitor
    if (targetDst == Target.a) {
      result.add(StimulusPairTarget(targetStim, nonCompetitorStimuli.last,
          Target.a, PairType.phonoTarget));
    } else {
      result.add(StimulusPairTarget(nonCompetitorStimuli.last, targetStim,
          Target.b, PairType.phonoTarget));
    }

    return result;
  }

  // this needs work, better to save all non-paired stimuli to property
  // and then shuffle them. this is just to remind me how to do it
  // this also means we need a bunch more images - probably 30 or so.
  StimulusPairTarget randomNonCompetingPair({Target? target}) {
    // this is mega inefficient, only needs doing once
    final List<String> nonCompetitorStimuli = _allStimuli
        .where((String s) =>
            !_phonologicalPairs.any((StimulusPair p) => p.isMember(s)))
        .toList();
    final String a = nonCompetitorStimuli.removeLast();
    final String b = nonCompetitorStimuli.removeLast();
    // if target is null, pick randomly
    target ??= TargetExtension.getRandom();
    return StimulusPairTarget(a, b, target, PairType.control);
  }

  List<StimulusPairTarget> randomNonCompetingPairs(int n) {
    final List<StimulusPairTarget> result = [];
    for (int i = 0; i < n; i++) {
      result.add(randomNonCompetingPair(target: TargetExtension.getRandom()));
    }
    return result;
  }

  List<int> distributeNonCompetingPairs(int bins, int values) {
    final List<int> result = [];
    final Random _rand = Random();
    int remainingNonPhono = values;
    for (int i = 0; i < bins; i++) {
      // e.g. nonphono = 18, and phono = 16, then
      // randomly between 1 and remaining nonphono
      // each bin needs at least 1
      remainingNonPhono = values - (bins - result.length) - result.sum;

      if (remainingNonPhono > 0) {
        result.add(_rand.nextInt(remainingNonPhono + 1) + 1);
      } else {
        result.add(1);
      }
    }
    remainingNonPhono = values - (bins - result.length) - result.sum;
    // add any leftovers to one of the gaps
    if (remainingNonPhono > 0) {
      result.last = result.last + remainingNonPhono;
    }
    // randomise distribution some more
    result.shuffle();
    return result;
  }

  List<StimulusPair> generateExperiment(
      {int n = 88, int nPhono = 16, int nPre = 3}) {
    final int nNonPhono = n - (nPhono * (nPre + 1));
    final Random _rand = Random();
    final List<int> nonPhonoDistribution =
        distributeNonCompetingPairs(nPhono + 1, nNonPhono);
    final List<StimulusPair> pairs = [];
    // distribute non-phonological stimuli

    for (int i = 0; i < nPhono; i++) {
      // add non-competitor (control) stimuli
      pairs.addAll(randomNonCompetingPairs(nonPhonoDistribution.removeLast()));
      // add phonological stimuli
      pairs.addAll(
          generatePhonologicalPairs((_phonologicalPairs..shuffle()).first,
              nPre: nPre,
              // randomize target
              targetSrc: TargetExtension.getRandom(),
              // randomize target destination
              targetDst: TargetExtension.getRandom()));
    }
    pairs.addAll(randomNonCompetingPairs(nonPhonoDistribution.removeLast()));
    return pairs;
  }

  // getters
  List<StimulusPair> get phonologicalPairs => _phonologicalPairs;
  List<String> get allStimuli => _allStimuli;
}
