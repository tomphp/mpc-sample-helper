import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('buttons are grey, blue or orange as on the front panel', () {
    final blue = [Control.chop, Control.mute, Control.loop];
    final orange = [Control.padFx, Control.knobFx];

    for (final control in blue) {
      expect(control.colour, ButtonColour.blue, reason: control.name);
    }
    expect(Control.sixteenLevels.colour, ButtonColour.blue);
    for (final control in orange) {
      expect(control.colour, ButtonColour.orange, reason: control.name);
    }
    expect(Control.sample.colour, ButtonColour.grey);
    expect(Control.shift.colour, ButtonColour.grey);
    expect(Control.stop.colour, ButtonColour.grey);
  });

  test('record and transport buttons carry their stripe', () {
    expect(Control.sampleRecord.stripe, ButtonStripe.red);
    expect(Control.seqRecord.stripe, ButtonStripe.red);
    expect(Control.stop.stripe, ButtonStripe.white);
    expect(Control.play.stripe, ButtonStripe.green);
    expect(Control.sample.stripe, isNull);
  });
}
