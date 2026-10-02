/// The number of Beats in a Bar and the note value of each Beat.
/// Emulated: the device itself only supports 4/4 (ADR 0002).
class TimeSignature {
  const TimeSignature(this.beats, this.noteValue);

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
