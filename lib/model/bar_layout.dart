import 'fraction.dart';
import 'position.dart';
import 'quantize.dart';
import 'time_signature.dart';

/// Ticks in one Device Bar: four Device Beats.
const ticksPerBar = 4 * ticksPerDeviceBeat;

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
  const BarLayout({
    required this.gridLines,
    required this.beats,
    required this.deviceBeats,
  });

  final List<GridLine> gridLines;
  final List<Beat> beats;

  /// Where each of the four Device Beats starts, as a fraction of the Bar.
  final List<double> deviceBeats;
}

BarLayout layoutBar(TimeSignature timeSignature, Quantize quantize) {
  final bar = Fraction(ticksPerBar);
  final beatLength = Fraction(ticksPerBar, timeSignature.beats);
  final step = _step(timeSignature, quantize);

  final gridLines = <GridLine>[];
  for (var ticks = Fraction(0); ticks < bar; ticks = ticks + step) {
    final beats = ticks / beatLength;
    gridLines.add(
      GridLine(
        number: gridLines.length + 1,
        barFraction: (ticks / bar).toDouble(),
        position: Position.fromTicks(ticks),
        beat: beats.isWhole ? beats.numerator + 1 : null,
      ),
    );
  }

  return BarLayout(
    gridLines: gridLines,
    beats: [
      for (var i = 0; i < timeSignature.beats; i++)
        Beat(number: i + 1, barFraction: i / timeSignature.beats),
    ],
    deviceBeats: const [0, 0.25, 0.5, 0.75],
  );
}

/// The Step in Ticks for every Quantize value in 4/4, the device's native
/// Time Signature. Every one is a whole number of Ticks.
Map<Quantize, int> standardStepsIn44() => {
  for (final quantize in Quantize.values)
    quantize: _step(const TimeSignature(4, 4), quantize).numerator,
};

/// Ticks between adjacent Grid Lines: the Bar is the Time Signature's
/// beats/noteValue of a whole note, and the Quantize is 1/n of a whole note.
Fraction _step(TimeSignature timeSignature, Quantize quantize) {
  final wholeNote = Fraction(
    ticksPerBar * timeSignature.noteValue,
    timeSignature.beats,
  );
  final step = wholeNote / Fraction(quantize.noteValue);
  return quantize.triplet ? step * Fraction(2, 3) : step;
}
