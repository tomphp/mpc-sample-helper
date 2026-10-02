import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

List<String> positions(BarLayout layout) => [
  for (final line in layout.gridLines) line.position.toString(),
];

void main() {
  const fourFour = TimeSignature.fourFour;

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

  test('every Quantize gives the expected number of Grid Lines in 4/4', () {
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

  test('4/4 has four evenly spaced Beats', () {
    final layout = layoutBar(fourFour, Quantize.sixteenth);

    expect([for (final beat in layout.beats) beat.number], [1, 2, 3, 4]);
    expect(
      [for (final beat in layout.beats) beat.barFraction],
      [
        0, 0.25, 0.5, 0.75, //
      ],
    );
  });

  group('other Time Signatures', () {
    test('3/4 at 1/4 puts its Beats at 1:000, 2:000 and 3:000', () {
      final layout = layoutBar(TimeSignature.threeFour, Quantize.quarter);

      expect(positions(layout), ['1:000', '2:000', '3:000']);
      expect([for (final line in layout.gridLines) line.beat], [1, 2, 3]);
      expect(
        [for (final beat in layout.beats) beat.barFraction],
        [0, 1 / 3, 2 / 3],
      );
    });

    test('6/8 at 1/16 counts six eighth-note Beats of 480 Ticks', () {
      final layout = layoutBar(TimeSignature.sixEight, Quantize.sixteenth);

      expect(positions(layout), [
        '1:000', '1:240', '2:000', '2:240', '3:000', '3:240', //
        '4:000', '4:240', '5:000', '5:240', '6:000', '6:240',
      ]);
      expect(
        [for (final line in layout.gridLines) line.beat],
        [1, null, 2, null, 3, null, 4, null, 5, null, 6, null],
      );
      expect(layout.beats, hasLength(6));
    });

    test('7/8 at 1/4 leaves a short final gap', () {
      final layout = layoutBar(TimeSignature.sevenEight, Quantize.quarter);

      expect(positions(layout), ['1:000', '3:000', '5:000', '7:000']);
      expect([for (final line in layout.gridLines) line.beat], [1, 3, 5, 7]);
      expect(layout.gridLines.last.barFraction, closeTo(6 / 7, 1e-9));
    });

    test('12/8 at 1/8T crosses Beats between Grid Lines', () {
      final layout = layoutBar(
        TimeSignature.twelveEight,
        Quantize.eighthTriplet,
      );

      expect(positions(layout).take(5), [
        '1:000', '1:320', '2:160', '3:000', '3:320', //
      ]);
      expect(layout.gridLines, hasLength(18));
      expect(layout.gridLines.last.position.toString(), '12:160');
    });

    test('2/4 at 1/4 is two Grid Lines, one on each Beat', () {
      final layout = layoutBar(TimeSignature.twoFour, Quantize.quarter);

      expect(positions(layout), ['1:000', '2:000']);
      expect([for (final line in layout.gridLines) line.beat], [1, 2]);
    });

    test('12/8 at 1/64 ends at 12:420', () {
      final layout = layoutBar(TimeSignature.twelveEight, Quantize.sixtyFourth);

      expect(layout.gridLines, hasLength(96));
      expect(layout.gridLines.last.position.toString(), '12:420');
      expect(layout.beats, hasLength(12));
    });
  });
}
