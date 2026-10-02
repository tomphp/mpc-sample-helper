import 'fraction.dart';

/// Ticks in one Device Beat.
const ticksPerDeviceBeat = 960;

/// Where something falls in the Device Bar, as Step Edit displays it:
/// Device Beat (from 1) and Tick, rounded to one decimal place.
class Position {
  /// The Position of a Tick counted from the start of the Device Bar.
  factory Position.fromTicks(Fraction ticks) {
    var deviceBeat = ticks.floor() ~/ ticksPerDeviceBeat;
    final tick = ticks - Fraction(deviceBeat * ticksPerDeviceBeat);

    // Round half up to tenths of a Tick.
    var tenths = (tick * Fraction(10) + Fraction(1, 2)).floor();
    if (tenths == ticksPerDeviceBeat * 10) {
      deviceBeat++;
      tenths = 0;
    }

    return Position._(deviceBeat + 1, tenths, isInexact: !tick.isWhole);
  }

  const Position._(this.deviceBeat, this._tenths, {required this.isInexact});

  /// Counted from 1.
  final int deviceBeat;

  /// The Tick within the Device Beat, in tenths, rounded half up.
  final int _tenths;

  /// True when the exact Tick is not a whole number, so the device can't
  /// hit it exactly.
  final bool isInexact;

  /// `beat:tick`, with the Tick padded to three digits and a decimal shown
  /// only when the rounded Tick isn't whole (e.g. `1:080`, `1:426.7`).
  @override
  String toString() {
    final whole = (_tenths ~/ 10).toString().padLeft(3, '0');
    final tenth = _tenths % 10;
    return '$deviceBeat:$whole${tenth == 0 ? '' : '.$tenth'}';
  }
}
