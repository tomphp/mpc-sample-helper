import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('every Q value has a whole-Tick Step', () {
    expect(
      {for (final q in Quantize.values) q: q.step},
      {
        Quantize.quarter: 960,
        Quantize.quarterTriplet: 640,
        Quantize.eighth: 480,
        Quantize.eighthTriplet: 320,
        Quantize.sixteenth: 240,
        Quantize.sixteenthTriplet: 160,
        Quantize.thirtySecond: 120,
        Quantize.thirtySecondTriplet: 80,
        Quantize.sixtyFourth: 60,
      },
    );
  });
}
