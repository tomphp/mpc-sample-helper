import 'fraction.dart';

/// Ticks in one Device Beat.
const ticksPerDeviceBeat = 960;

/// Where something falls in the Device Bar, as Step Edit displays it:
/// Device Beat (from 1) and Tick.
class Position {
  /// The Position of a Tick counted from the start of the Device Bar.
  factory Position.fromTicks(Fraction ticks) {
    final deviceBeat = ticks.floor() ~/ ticksPerDeviceBeat;
    final tick = ticks - Fraction(deviceBeat * ticksPerDeviceBeat);
    return Position._(deviceBeat + 1, tick.floor(), isInexact: !tick.isWhole);
  }

  const Position._(this.deviceBeat, this.tick, {required this.isInexact});

  final int deviceBeat;
  final int tick;

  /// True when the exact Tick is not a whole number, so the device can't
  /// hit it exactly.
  final bool isInexact;

  @override
  String toString() => '$deviceBeat:${tick.toString().padLeft(3, '0')}';
}
