import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('reads a Tip with its title, outcome, steps and note', () {
    final tips = parseTips('''
tips:
  - title: Layer two pads
    outcome: One pad also triggers another
    steps:
      - Select the pad
      - Choose the linked pad
    note: Only within the same Pad Bank
''');

    final tip = tips.single;
    expect(tip.title, 'Layer two pads');
    expect(tip.outcome, 'One pad also triggers another');
    expect(tip.steps, const [
      TipLine([PlainText('Select the pad')]),
      TipLine([PlainText('Choose the linked pad')]),
    ]);
    expect(
      tip.note,
      const TipLine([PlainText('Only within the same Pad Bank')]),
    );
  });

  test('keeps Tips in file order; a note is optional', () {
    final tips = parseTips('''
tips:
  - title: First
    outcome: One
    steps: [Do it]
  - title: Second
    outcome: Two
    steps: [Do it again]
''');

    expect([for (final tip in tips) tip.title], ['First', 'Second']);
    expect(tips.first.note, isNull);
  });

  test('reads bracketed Controls in steps and notes as Control segments', () {
    final tip = parseTips('''
tips:
  - title: Shift one pad
    outcome: A late snare
    steps:
      - Hold [SHIFT] and press [pad 14]
      - "[K2][B3] then [STOP]"
    note: Use [pads 1–8], [any pad] or [K1 / K2 / K3]
''').single;

    expect(tip.steps, const [
      TipLine([
        PlainText('Hold '),
        ControlMention(SingleControl(Control.shift)),
        PlainText(' and press '),
        ControlMention(Pad(14)),
      ]),
      TipLine([
        ControlMention(SingleControl(Control.k2)),
        ControlMention(SingleControl(Control.b3)),
        PlainText(' then '),
        ControlMention(SingleControl(Control.stop)),
      ]),
    ]);
    expect(
      tip.note,
      const TipLine([
        PlainText('Use '),
        ControlMention(PadRange(1, 8)),
        PlainText(', '),
        ControlMention(AnyPad()),
        PlainText(' or '),
        ControlMention(
          ControlChoice([
            SingleControl(Control.k1),
            SingleControl(Control.k2),
            SingleControl(Control.k3),
          ]),
        ),
      ]),
    );
  });

  group('malformed data names the Tip', () {
    void expectError(String yaml, String message) => expect(
      () => parseTips(yaml),
      throwsA(
        isA<TipDataException>().having(
          (error) => error.message,
          'message',
          message,
        ),
      ),
    );

    test('no top-level tips list', () {
      expectError('tip: []', 'expected a top-level "tips" list');
    });

    test('a missing title', () {
      expectError('''
tips:
  - title: First
    outcome: One
    steps: [Do it]
  - outcome: Two
    steps: [Do it]
''', 'Tip 2 has no title');
    });

    test('a missing outcome', () {
      expectError('''
tips:
  - title: Layer
    steps: [Do it]
''', 'Tip 1 "Layer": missing outcome');
    });

    test('missing steps', () {
      expectError('''
tips:
  - title: Layer
    outcome: One
''', 'Tip 1 "Layer": no steps');
    });

    test('empty steps', () {
      expectError('''
tips:
  - title: Layer
    outcome: One
    steps: []
''', 'Tip 1 "Layer": no steps');
    });

    test('a step that is not text', () {
      expectError('''
tips:
  - title: Layer
    outcome: One
    steps:
      - Do it
      - press: K2
''', 'Tip 1 "Layer", step 2: must be text');
    });

    test('a note that is not text', () {
      expectError('''
tips:
  - title: Layer
    outcome: One
    steps: [Do it]
    note: [a, b]
''', 'Tip 1 "Layer", note: must be text');
    });

    test('an unknown key', () {
      expectError('''
tips:
  - title: Layer
    outcome: One
    steps: [Do it]
    nte: Careful
''', 'Tip 1 "Layer": unknown key "nte"');
    });

    test('an unknown Control in a marker', () {
      expectError('''
tips:
  - title: Layer
    outcome: One
    steps:
      - Do it
      - Turn [K1 / K4]
''', 'Tip 1 "Layer", step 2: unknown Control "K4"');
    });

    test('an unclosed marker', () {
      expectError('''
tips:
  - title: Layer
    outcome: One
    steps: [Do it]
    note: Turn [K2 slowly
''', 'Tip 1 "Layer", note: unmatched bracket');
    });

    test('an empty marker', () {
      expectError('''
tips:
  - title: Layer
    outcome: One
    steps: ["Press [] now"]
''', 'Tip 1 "Layer", step 1: empty Control marker');
    });
  });
}
