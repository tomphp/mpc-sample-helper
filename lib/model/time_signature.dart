/// The number of Beats in a Bar and the note value of each Beat.
/// Emulated: the device itself only supports 4/4 (ADR 0002).
class TimeSignature {
  const TimeSignature(this.beats, this.noteValue)
    : assert(beats >= 1 && beats <= 16),
      assert(noteValue == 4 || noteValue == 8);

  /// 4/4, the device's own Time Signature.
  static const standard = TimeSignature(4, 4);

  static const beatChoices = [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, //
  ];
  static const noteValueChoices = [4, 8];

  final int beats;
  final int noteValue;

  @override
  bool operator ==(Object other) =>
      other is TimeSignature &&
      other.beats == beats &&
      other.noteValue == noteValue;

  @override
  int get hashCode => Object.hash(beats, noteValue);

  @override
  String toString() => '$beats/$noteValue';
}
