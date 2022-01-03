import 'package:flutter_test/flutter_test.dart';
import 'package:touchtracker/src/stimuli.dart';
import 'package:collection/collection.dart';

void main() {
  test('Stimulus pair objects should be equal with same order', () {
    final pair1 = StimulusPair('item1', 'item2');
    final pair2 = StimulusPair('item1', 'item2');
    expect(pair2 == pair1, true);
  });
  test('Stimulus pair objects should be equal regardless of order', () {
    final pair1 = StimulusPair('item1', 'item2');
    final pair2 = StimulusPair('item2', 'item1');
    expect(pair2 == pair1, true);
  });

  test('Stimulus pair objects should not be equal with 1 shared item', () {
    final pair1 = StimulusPair('item1', 'item2');
    final pair2 = StimulusPair('item3', 'item1');
    expect(pair2 == pair1, false);
  });

  test('Stimulus pair objects should not be equal with 0 shared items', () {
    final pair1 = StimulusPair('item1', 'item2');
    final pair2 = StimulusPair('item3', 'item4');
    expect(pair2 == pair1, false);
  });

  test('Stimulus pair correctly identifies a and b members', () {
    final pair1 = StimulusPair('item1', 'item2');
    expect(pair1.isA('item1'), true);
    expect(pair1.isA('item2'), false);
    expect(pair1.isB('item2'), true);
    expect(pair1.isB('item1'), false);
  });

  test('Stimulus pair correctly identifies members', () {
    final pair1 = StimulusPair('item1', 'item2');
    expect(pair1.isMember('item1'), true);
    expect(pair1.isMember('item2'), true);
    expect(pair1.isMember('item3'), false);
  });

  test('Stimulus pair correctly identifies shared members', () {
    final pair1 = StimulusPair('item1', 'item2');
    final pair2 = StimulusPair('item1', 'item2');
    final pair3 = StimulusPair('item1', 'item3');
    final pair4 = StimulusPair('item4', 'item3');
    expect(pair1.hasSharedMember(pair2), true);
    expect(pair1.hasSharedMember(pair3), true);
    expect(pair1.hasSharedMember(pair4), false);
  });

  test('Stimuli object should generate random non-competing stimulus pair', () {
    Stimuli stimuli = Stimuli();
    StimulusPair pair = stimuli.randomNonCompetingPair();
    expect(pair.a, isNotNull);
    expect(pair.b, isNotNull);
    List<StimulusPair> phonoPairs = stimuli.phonologicalPairs;
    expect(phonoPairs.contains(pair), false);
    expect(phonoPairs.any((StimulusPair p) => p.hasSharedMember(pair)), false);
  });

  test('stimuli object correctly creates a distribution of non-competing pairs',
      () {
    Stimuli stimuli = Stimuli();
    int nPhono = 16;
    int nRemaining = 25;
    List<int> dist =
        stimuli.distributeNonCompetingPairs(nPhono + 1, nRemaining);
    expect(dist.length, nPhono + 1);
    expect(dist.sum, nRemaining);
  });

  test('Stimuli object should generate correct number of experiment items', () {
    Stimuli stimuli = Stimuli();
    List<StimulusPair> experiment =
        stimuli.generateExperiment(n: 88, nPhono: 16, nPre: 3);
    expect(experiment.length, 88);
  });

  test('Stimuli object random non-competing pair generates correct type', () {
    Stimuli stimuli = Stimuli();
    StimulusPairTarget pair = stimuli.randomNonCompetingPair();
    Target target = Target.b;
    StimulusPairTarget pair2 = stimuli.randomNonCompetingPair(target: target);

    expect(pair.pairType, PairType.control);
    expect(pair2.pairType, PairType.control);
    expect(pair2.target, target);
  });

  test('Stimuli object phono pair creates correct number and type', () {
    Stimuli stimuli = Stimuli();
    List<StimulusPair> phonoPairs = stimuli.phonologicalPairs;
    phonoPairs.shuffle();
    StimulusPair pair = phonoPairs.first;
    Target target = Target.a;
    Target competitor = Target.b;
    List<StimulusPairTarget> phono = stimuli.generatePhonologicalPairs(pair,
        targetSrc: target, nPre: 3, targetDst: target);

    expect(phono.length, 4);

    expect(phono[0].isMember(pair.getCompetitorFromTarget(target)), true);
    expect(phono[0].isMember(pair.getFromTarget(target)), false);
    expect(phono[0].target, competitor);
    expect(phono[0].pairType, PairType.phonoCompetitor);

    expect(phono[1].isMember(pair.getCompetitorFromTarget(target)), true);
    expect(phono[1].isMember(pair.getFromTarget(target)), false);
    expect(phono[1].target, competitor);
    expect(phono[1].pairType, PairType.phonoCompetitor);

    expect(phono[2].isMember(pair.getCompetitorFromTarget(target)), true);
    expect(phono[2].isMember(pair.getFromTarget(target)), false);
    expect(phono[2].target, competitor);
    expect(phono[2].pairType, PairType.phonoCompetitor);

    expect(phono[3].isMember(pair.getCompetitorFromTarget(target)), false);
    expect(phono[3].isMember(pair.getFromTarget(target)), true);
    expect(phono[3].target, target);
    expect(phono[3].pairType, PairType.phonoTarget);
  });
}
