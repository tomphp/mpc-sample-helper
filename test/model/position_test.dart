import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('Ticks are padded to three digits', () {
    final position = Position.fromTicks(1040, ticksPerBeat: 960);

    expect(position.toString(), '2:080');
  });

  test('Beats of an eighth note are 480 Ticks long', () {
    expect(Position.fromTicks(2640, ticksPerBeat: 480).toString(), '6:240');
    expect(Position.fromTicks(479, ticksPerBeat: 480).toString(), '1:479');
  });
}
