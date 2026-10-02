/// Ticks in one quarter note.
const ticksPerQuarterNote = 960;

/// The number of Beats in a Bar and the note value of each Beat: exactly the
/// Time Signatures the device offers, in its order (ADR 0003).
enum TimeSignature {
  twoFour(2, 4),
  threeFour(3, 4),
  fourFour(4, 4),
  fiveFour(5, 4),
  sixFour(6, 4),
  sevenFour(7, 4),
  sixEight(6, 8),
  sevenEight(7, 8),
  nineEight(9, 8),
  tenEight(10, 8),
  elevenEight(11, 8),
  twelveEight(12, 8);

  const TimeSignature(this.beats, this.noteValue);

  /// 4/4, the default.
  static const standard = fourFour;

  final int beats;
  final int noteValue;

  /// 960 for a quarter note, 480 for an eighth.
  int get ticksPerBeat => ticksPerQuarterNote * 4 ~/ noteValue;

  int get ticksPerBar => beats * ticksPerBeat;

  @override
  String toString() => '$beats/$noteValue';
}
