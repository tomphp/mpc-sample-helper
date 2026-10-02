import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('a Time Signature has 1 to 16 Beats of a quarter or an eighth note', () {
    expect(TimeSignature.beatChoices, [
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, //
    ]);
    expect(TimeSignature.noteValueChoices, [4, 8]);
  });

  test('the default Time Signature is 4/4', () {
    expect(TimeSignature.standard, const TimeSignature(4, 4));
  });
}
