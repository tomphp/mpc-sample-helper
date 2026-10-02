import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('exact Ticks are padded to three digits with no decimal', () {
    final position = Position.fromTicks(Fraction(1040));

    expect(position.toString(), '2:080');
    expect(position.isInexact, isFalse);
  });

  test('Inexact Ticks round half up to one decimal place', () {
    expect(Position.fromTicks(Fraction(2105, 20)).toString(), '1:105.3');
    expect(Position.fromTicks(Fraction(2101, 20)).toString(), '1:105.1');
  });

  test(
    'an Inexact Tick that rounds to 960 carries to the next Device Beat',
    () {
      final position = Position.fromTicks(Fraction(19199, 20)); // 959.95

      expect(position.toString(), '2:000');
      expect(position.isInexact, isTrue);
    },
  );

  test('an Inexact Tick that rounds to a whole number shows no decimal', () {
    final position = Position.fromTicks(Fraction(4001, 40)); // 100.025

    expect(position.toString(), '1:100');
    expect(position.isInexact, isTrue);
  });
}
