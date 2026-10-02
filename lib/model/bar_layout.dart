import 'position.dart';
import 'quantize.dart';
import 'time_signature.dart';

/// One position produced by the Quantize within the Bar.
class GridLine {
  const GridLine({
    required this.number,
    required this.barFraction,
    required this.position,
    required this.beat,
  });

  /// Counted from 1.
  final int number;

  /// Where it falls across the Bar, from 0 (inclusive) to 1 (exclusive).
  final double barFraction;

  final Position position;

  /// The number of the Beat this Grid Line lands on exactly, if any.
  final int? beat;
}

/// One Beat of the Time Signature.
class Beat {
  const Beat({required this.number, required this.barFraction});

  /// Counted from 1.
  final int number;

  final double barFraction;
}

/// Everything STEP EDIT draws for one Bar.
class BarLayout {
  const BarLayout({required this.gridLines, required this.beats});

  final List<GridLine> gridLines;
  final List<Beat> beats;
}

BarLayout layoutBar(TimeSignature timeSignature, Quantize quantize) {
  final bar = timeSignature.ticksPerBar;
  final beatLength = timeSignature.ticksPerBeat;

  final gridLines = <GridLine>[];
  for (var ticks = 0; ticks < bar; ticks += quantize.step) {
    final position = Position.fromTicks(ticks, ticksPerBeat: beatLength);
    gridLines.add(
      GridLine(
        number: gridLines.length + 1,
        barFraction: ticks / bar,
        position: position,
        beat: position.tick == 0 ? position.beat : null,
      ),
    );
  }

  return BarLayout(
    gridLines: gridLines,
    beats: [
      for (var i = 0; i < timeSignature.beats; i++)
        Beat(number: i + 1, barFraction: i / timeSignature.beats),
    ],
  );
}
