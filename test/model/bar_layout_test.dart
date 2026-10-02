import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

List<String> positions(BarLayout layout) => [
  for (final line in layout.gridLines) line.position.toString(),
];

void main() {
  const fourFour = TimeSignature(4, 4);

  test('4/4 at 1/16 has 16 Grid Lines from 1:000 to 4:720', () {
    final layout = layoutBar(fourFour, Quantize.sixteenth);

    expect(positions(layout), [
      '1:000', '1:240', '1:480', '1:720', //
      '2:000', '2:240', '2:480', '2:720',
      '3:000', '3:240', '3:480', '3:720',
      '4:000', '4:240', '4:480', '4:720',
    ]);
  });

  test('4/4 at 1/4T has 6 Grid Lines ending at 4:320', () {
    final layout = layoutBar(fourFour, Quantize.quarterTriplet);

    expect(positions(layout), [
      '1:000', '1:640', '2:320', '3:000', '3:640', '4:320', //
    ]);
  });

  test('every Quantize gives only exact Positions in 4/4', () {
    const gridLineCounts = {
      Quantize.quarter: 4,
      Quantize.quarterTriplet: 6,
      Quantize.eighth: 8,
      Quantize.eighthTriplet: 12,
      Quantize.sixteenth: 16,
      Quantize.sixteenthTriplet: 24,
      Quantize.thirtySecond: 32,
      Quantize.thirtySecondTriplet: 48,
      Quantize.sixtyFourth: 64,
    };

    for (final MapEntry(key: quantize, value: count)
        in gridLineCounts.entries) {
      final layout = layoutBar(fourFour, quantize);
      expect(layout.gridLines, hasLength(count), reason: quantize.label);
      expect(
        layout.gridLines.where((line) => line.position.isInexact),
        isEmpty,
        reason: quantize.label,
      );
    }
  });

  test('Grid Lines are numbered from 1 and know their fraction of the Bar', () {
    final layout = layoutBar(fourFour, Quantize.eighth);

    expect(
      [for (final line in layout.gridLines) line.number],
      [
        1, 2, 3, 4, 5, 6, 7, 8, //
      ],
    );
    expect(
      [for (final line in layout.gridLines) line.barFraction],
      [
        0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, //
      ],
    );
  });

  test('Grid Lines on a Beat carry its number; others carry none', () {
    final layout = layoutBar(fourFour, Quantize.eighth);

    expect(
      [for (final line in layout.gridLines) line.beat],
      [
        1, null, 2, null, 3, null, 4, null, //
      ],
    );
  });

  test('4/4 has four Beats and four Device Beats at the quarters', () {
    final layout = layoutBar(fourFour, Quantize.sixteenth);

    expect([for (final beat in layout.beats) beat.number], [1, 2, 3, 4]);
    expect(
      [for (final beat in layout.beats) beat.barFraction],
      [
        0, 0.25, 0.5, 0.75, //
      ],
    );
    expect(layout.deviceBeats, [0, 0.25, 0.5, 0.75]);
  });

  group('emulated Time Signatures', () {
    test('3/4 at 1/4 puts its Beats at 1:000, 2:320 and 3:640', () {
      final layout = layoutBar(const TimeSignature(3, 4), Quantize.quarter);

      expect(positions(layout), ['1:000', '2:320', '3:640']);
      expect([for (final line in layout.gridLines) line.beat], [1, 2, 3]);
      expect(
        [for (final beat in layout.beats) beat.barFraction],
        [0, 1 / 3, 2 / 3],
      );
    });

    test('3/4 at 1/8T has Inexact Positions rounded to one decimal place', () {
      final layout = layoutBar(
        const TimeSignature(3, 4),
        Quantize.eighthTriplet,
      );
      final lines = layout.gridLines;

      expect(positions(layout).take(4), [
        '1:000',
        '1:426.7',
        '1:853.3',
        '2:320',
      ]);
      expect(
        [for (final line in lines.take(4)) line.position.isInexact],
        [false, true, true, false],
      );
    });

    test('7/8 at 1/4 leaves a short final gap', () {
      final layout = layoutBar(const TimeSignature(7, 8), Quantize.quarter);

      expect(positions(layout), ['1:000', '2:137.1', '3:274.3', '4:411.4']);
      expect([for (final line in layout.gridLines) line.beat], [1, 3, 5, 7]);
      expect(layout.gridLines.last.barFraction, closeTo(6 / 7, 1e-9));
    });

    test('1/4 at 1/4 is a single Grid Line on Beat 1', () {
      final layout = layoutBar(const TimeSignature(1, 4), Quantize.quarter);

      expect(positions(layout), ['1:000']);
      expect([for (final line in layout.gridLines) line.beat], [1]);
      expect(layout.beats, hasLength(1));
    });

    test('5/8 at 1/8 spreads five exact Beats across the Device Bar', () {
      final layout = layoutBar(const TimeSignature(5, 8), Quantize.eighth);

      expect(positions(layout), ['1:000', '1:768', '2:576', '3:384', '4:192']);
      expect([for (final line in layout.gridLines) line.beat], [1, 2, 3, 4, 5]);
    });

    test('16/8 at 1/16 has 32 Grid Lines, every other one on a Beat', () {
      final layout = layoutBar(const TimeSignature(16, 8), Quantize.sixteenth);

      expect(layout.gridLines, hasLength(32));
      expect(layout.gridLines.last.position.toString(), '4:840');
      expect(layout.gridLines[1].beat, isNull);
      expect(layout.gridLines[30].beat, 16);
      expect(layout.beats, hasLength(16));
    });
  });
}
