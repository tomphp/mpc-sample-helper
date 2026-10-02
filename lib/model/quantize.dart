/// The note value that divides a Bar into evenly spaced Grid Lines.
/// Labelled `Q` on the device.
enum Quantize {
  quarter(4, triplet: false),
  quarterTriplet(4, triplet: true),
  eighth(8, triplet: false),
  eighthTriplet(8, triplet: true),
  sixteenth(16, triplet: false),
  sixteenthTriplet(16, triplet: true),
  thirtySecond(32, triplet: false),
  thirtySecondTriplet(32, triplet: true),
  sixtyFourth(64, triplet: false);

  const Quantize(this.noteValue, {required this.triplet});

  /// The n in 1/n.
  final int noteValue;
  final bool triplet;

  String get label => '1/$noteValue${triplet ? 'T' : ''}';
}
