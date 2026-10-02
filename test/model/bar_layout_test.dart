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
}
