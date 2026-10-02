import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('the Time Signatures are exactly the ones the device offers', () {
    expect(
      [for (final t in TimeSignature.values) '$t'],
      [
        '2/4', '3/4', '4/4', '5/4', '6/4', '7/4', //
        '6/8', '7/8', '9/8', '10/8', '11/8', '12/8',
      ],
    );
  });

  test('the default Time Signature is 4/4', () {
    expect(TimeSignature.standard, TimeSignature.fourFour);
  });

  test('a Beat is 960 Ticks in x/4 and 480 in x/8', () {
    expect(TimeSignature.threeFour.ticksPerBeat, 960);
    expect(TimeSignature.threeFour.ticksPerBar, 2880);
    expect(TimeSignature.sevenEight.ticksPerBeat, 480);
    expect(TimeSignature.sevenEight.ticksPerBar, 3360);
  });
}
