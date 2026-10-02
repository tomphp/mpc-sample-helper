/// An exact rational number, so Grid Line positions never pick up
/// floating-point error.
class Fraction implements Comparable<Fraction> {
  factory Fraction(int numerator, [int denominator = 1]) {
    if (denominator == 0) throw ArgumentError('denominator must not be 0');
    final sign = denominator < 0 ? -1 : 1;
    final divisor = numerator.gcd(denominator);
    return Fraction._(
      sign * numerator ~/ divisor,
      sign * denominator ~/ divisor,
    );
  }

  const Fraction._(this.numerator, this.denominator);

  final int numerator;
  final int denominator;

  bool get isWhole => denominator == 1;

  /// The largest whole number not greater than this.
  int floor() => (numerator / denominator).floor();

  Fraction operator +(Fraction other) => Fraction(
    numerator * other.denominator + other.numerator * denominator,
    denominator * other.denominator,
  );

  Fraction operator -(Fraction other) =>
      this + Fraction(-other.numerator, other.denominator);

  Fraction operator *(Fraction other) =>
      Fraction(numerator * other.numerator, denominator * other.denominator);

  Fraction operator /(Fraction other) =>
      Fraction(numerator * other.denominator, denominator * other.numerator);

  bool operator <(Fraction other) => compareTo(other) < 0;

  double toDouble() => numerator / denominator;

  @override
  int compareTo(Fraction other) =>
      (numerator * other.denominator).compareTo(other.numerator * denominator);

  @override
  bool operator ==(Object other) =>
      other is Fraction &&
      other.numerator == numerator &&
      other.denominator == denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString() => '$numerator/$denominator';
}
