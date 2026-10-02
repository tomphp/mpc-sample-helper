/// Where something falls in the Bar, as Step Edit displays it: Beat (from 1)
/// and Tick.
class Position {
  /// The Position of a Tick counted from the start of the Bar, in Beats of
  /// [ticksPerBeat] Ticks.
  Position.fromTicks(int ticks, {required int ticksPerBeat})
    : beat = ticks ~/ ticksPerBeat + 1,
      tick = ticks % ticksPerBeat;

  /// Counted from 1.
  final int beat;

  /// The Tick within the Beat.
  final int tick;

  /// `beat:tick`, with the Tick padded to three digits (e.g. `1:080`).
  @override
  String toString() => '$beat:${tick.toString().padLeft(3, '0')}';
}
