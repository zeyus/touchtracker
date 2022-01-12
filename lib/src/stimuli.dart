import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';

// enum of target a or b
enum Target { a, b }

enum PairType { control, phonoPrime, phonoCritical, motorPrime, motorCritical }

// add extension to Target to get random target
extension TargetExtension on Target {
  static Target getRandom() {
    var random = Random().nextInt(2);
    return Target.values[random];
  }
}

extension PairTypeExtension on PairType {
  static String getType(PairType p) {
    switch (p) {
      case PairType.control:
        return 'control';
      case PairType.phonoPrime:
      case PairType.phonoCritical:
        return 'phono';
      case PairType.motorPrime:
      case PairType.motorCritical:
        return 'motor';
    }
  }

  static String getSubType(PairType p) {
    switch (p) {
      case PairType.control:
        return 'control';
      case PairType.phonoPrime:
      case PairType.motorPrime:
        return 'prime';
      case PairType.phonoCritical:
      case PairType.motorCritical:
        return 'critical';
    }
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

  StimulusPairTarget(T1 a, T2 b, this._target, this._pairType) : super(a, b) {
    if (a == b) {
      throw ArgumentError('Targets a and b must not be identical');
    }
  }

  // static method to create a StimulusPairTarget from a StimulusPair
  static StimulusPairTarget<T1, T2> fromStimulusPair<T1, T2>(
      StimulusPair<T1, T2> pair, Target target, PairType pairType) {
    return StimulusPairTarget(pair.a, pair.b, target, pairType);
  }

  String get title {
    String title = '';
    switch (_pairType) {
      case PairType.control:
        title = 'Control: ';
        break;
      case PairType.phonoCritical:
        title = 'Phono critical: ';
        break;
      case PairType.phonoPrime:
        title = 'Phono prime: ';
        break;
      case PairType.motorPrime:
        title = 'Motor prime: ';
        break;
      case PairType.motorCritical:
        title = 'Motor critical: ';
        break;
    }
    title += a.toString();
    if (_target == Target.a) {
      title += '*';
    }
    title += ' vs. ';
    title += b.toString();
    if (_target == Target.b) {
      title += '*';
    }
    return title;
  }

  getTargetStimulus() => getFromTarget(_target);
  getCompetitorStimulus() => getCompetitorFromTarget(_target);

  // getters
  Target get target => _target;
  Target get competitor => _target == Target.a ? Target.b : Target.a;
  PairType get pairType => _pairType;
}

class Stimuli {
  late final List<String> _nonPhonologicalStimuli;
  final Map<String, String> _assetNames = {
    'ball': 'assets/vector/ball.svg',
    'balloon': 'assets/vector/balloon.svg',
    'banana': 'assets/vector/banana.svg',
    'barrel': 'assets/vector/barrel.svg',
    'bat': 'assets/vector/bat.svg',
    'bicycle': 'assets/vector/bicycle.svg',
    'boar': 'assets/vector/boar.svg',
    'book': 'assets/vector/book.svg',
    'butterfly': 'assets/vector/butterfly.svg',
    'cactus': 'assets/vector/cactus.svg',
    'cake': 'assets/vector/cake.svg',
    'camera': 'assets/vector/camera.svg',
    'candle': 'assets/vector/candle.svg',
    'candy': 'assets/vector/candy.svg',
    'cat': 'assets/vector/cat.svg',
    'cherries': 'assets/vector/cherries.svg',
    'cloud': 'assets/vector/cloud.svg',
    'clown': 'assets/vector/clown.svg',
    'coffee': 'assets/vector/coffee.svg',
    'cookie': 'assets/vector/cookie.svg',
    'dog': 'assets/vector/dog.svg',
    'dolphin': 'assets/vector/dolphin.svg',
    'donut': 'assets/vector/donut.svg',
    'fish': 'assets/vector/fish.svg',
    'fist': 'assets/vector/fist.svg',
    'flashlight': 'assets/vector/flashlight.svg',
    'gift': 'assets/vector/gift.svg',
    'guitar': 'assets/vector/guitar.svg',
    'key': 'assets/vector/key.svg',
    'lightbulb': 'assets/vector/lightbulb.svg',
    'microphone': 'assets/vector/microphone.svg',
    'microscope': 'assets/vector/microscope.svg',
    'monkey': 'assets/vector/monkey.svg',
    'moon': 'assets/vector/moon.svg',
    'mouse': 'assets/vector/mouse.svg',
    'mouth': 'assets/vector/mouth.svg',
    'pear': 'assets/vector/pear.svg',
    'pencil': 'assets/vector/pencil.svg',
    'pepper': 'assets/vector/pepper.svg',
    'phone': 'assets/vector/phone.svg',
    'printer': 'assets/vector/printer.svg',
    'rainbow': 'assets/vector/rainbow.svg',
    'road': 'assets/vector/road.svg',
    'robe': 'assets/vector/robe.svg',
    'rocket': 'assets/vector/rocket.svg',
    'ruler': 'assets/vector/ruler.svg',
    'seashell': 'assets/vector/seashell.svg',
    'sheep': 'assets/vector/sheep.svg',
    'shield': 'assets/vector/shield.svg',
    'ship': 'assets/vector/ship.svg',
    'shoe': 'assets/vector/shoe.svg',
    'skate': 'assets/vector/skate.svg',
    'snake': 'assets/vector/snake.svg',
    'snowman': 'assets/vector/snowman.svg',
    'spoon': 'assets/vector/spoon.svg',
    'strawberry': 'assets/vector/strawberry.svg',
    'sunflower': 'assets/vector/sunflower.svg',
    'track': 'assets/vector/track.svg',
    'trophy': 'assets/vector/trophy.svg',
    'truck': 'assets/vector/truck.svg',
    'volcano': 'assets/vector/volcano.svg',
    'watermelon': 'assets/vector/watermelon.svg',
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

  get nonPhonologicalStimuli => _nonPhonologicalStimuli;

  Stimuli() {
    _allStimuli.addAll(_assetNames.keys);
    _nonPhonologicalStimuli = _allStimuli
        .where((String s) =>
            !_phonologicalPairs.any((StimulusPair p) => p.isMember(s)))
        .toList();
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
      {Target targetSrc = Target.a, nPrime = 3, Target targetDst = Target.a}) {
    // result pairs
    final List<StimulusPairTarget> result = [];
    // exclude target and competitor from list of all stimuli
    final List<String> nonCompetitorStimuli =
        _allStimuli.where((String s) => s != pair.a && s != pair.b).toList();

    final String critical = pair.getFromTarget(targetSrc);
    final String prime = pair.getCompetitorFromTarget(targetSrc);
    // shuffle stimuli
    nonCompetitorStimuli.shuffle();
    // generate 3 pairs with target and non competitor
    for (int i = 0; i < nPrime; i++) {
      // get competitor from list of stimuli and remove it from list
      final String nonCompetitor = nonCompetitorStimuli.removeLast();
      if (targetDst == Target.a) {
        result.add(StimulusPairTarget(
            nonCompetitor, prime, Target.b, PairType.phonoPrime));
      } else {
        result.add(StimulusPairTarget(
            prime, nonCompetitor, Target.a, PairType.phonoPrime));
      }
    }
    // finally add target b and random non competitor
    if (targetDst == Target.a) {
      result.add(StimulusPairTarget(critical, nonCompetitorStimuli.last,
          Target.a, PairType.phonoCritical));
    } else {
      result.add(StimulusPairTarget(nonCompetitorStimuli.last, critical,
          Target.b, PairType.phonoCritical));
    }

    return result;
  }

  List<StimulusPairTarget> generateMotorPairs(String prime,
      {nPrime = 3, Target targetDst = Target.a}) {
    final List<StimulusPairTarget> result = [];
    final List<String> nonPhonoStimuli =
        List.from(_nonPhonologicalStimuli.where((element) => element != prime));
    // shuffle stimuli
    nonPhonoStimuli.shuffle();
    // generate 3 pairs with target and non competitor
    for (int i = 0; i < nPrime; i++) {
      // get competitor from list of stimuli and remove it from list
      final String nonCompetitor = nonPhonoStimuli.removeLast();
      if (targetDst == Target.a) {
        result.add(StimulusPairTarget(
            nonCompetitor, prime, Target.b, PairType.motorPrime));
      } else {
        result.add(StimulusPairTarget(
            prime, nonCompetitor, Target.a, PairType.motorPrime));
      }
    }

    result.add(StimulusPairTarget(nonPhonoStimuli.last, nonPhonoStimuli.first,
        targetDst, PairType.motorCritical));

    return result;
  }

  // this needs work, better to save all non-paired stimuli to property
  // and then shuffle them. this is just to remind me how to do it
  // this also means we need a bunch more images - probably 30 or so.
  StimulusPairTarget randomNonPhonologicalPair({Target? target}) {
    // copy so shuffle doesn't modify original
    final List<String> nonPhonoStimuli = List.from(_nonPhonologicalStimuli);
    nonPhonoStimuli.shuffle();
    final String a = nonPhonoStimuli.removeLast();
    final String b = nonPhonoStimuli.removeLast();
    // if target is null, pick randomly
    target ??= TargetExtension.getRandom();
    return StimulusPairTarget(a, b, target, PairType.control);
  }

  List<StimulusPairTarget> randomNonPhonologicalPairs(int n) {
    final List<StimulusPairTarget> result = [];
    for (int i = 0; i < n; i++) {
      result
          .add(randomNonPhonologicalPair(target: TargetExtension.getRandom()));
    }
    return result;
  }

  List<int> distributeNonPhonologicalPairs(int bins, int values) {
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

  List<StimulusPairTarget> generateExperiment(
      {int n = 88, int nPhono = 8, int nMotor = 8, int nPrime = 3}) {
    final int nNonPhono = n - ((nPhono + nMotor) * (nPrime + 1));
    final List<int> nonPhonoDistribution =
        distributeNonPhonologicalPairs(nPhono + nMotor + 1, nNonPhono);
    final List<StimulusPairTarget> pairs = [];
    // distribute non-phonological stimuli
    List<List<StimulusPairTarget>> conditions = [];
    for (int i = 0; i < nPhono; i++) {
      conditions
          .add(generatePhonologicalPairs((_phonologicalPairs..shuffle()).first,
              nPrime: nPrime,
              // randomize target
              targetSrc: TargetExtension.getRandom(),
              // randomize target destination
              targetDst: TargetExtension.getRandom()));
    }
    for (int i = 0; i < nMotor; i++) {
      conditions
          .add(generateMotorPairs((_nonPhonologicalStimuli..shuffle()).first,
              nPrime: nPrime,
              // randomize target destination
              targetDst: TargetExtension.getRandom()));
    }
    conditions.shuffle();
    for (int i = 0; i < conditions.length; i++) {
      // add non-competitor (control) stimuli
      pairs.addAll(
          randomNonPhonologicalPairs(nonPhonoDistribution.removeLast()));
      // add phonological stimuli
      pairs.addAll(conditions[i]);
    }
    pairs.addAll(randomNonPhonologicalPairs(nonPhonoDistribution.removeLast()));
    return pairs;
  }

  // getters
  List<StimulusPair> get phonologicalPairs => _phonologicalPairs;
  List<String> get allStimuli => _allStimuli;
}
