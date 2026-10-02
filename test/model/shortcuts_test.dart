import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('reads a Shortcut with its Mode, Gesture and effect', () {
    final modes = parseShortcuts('''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture:
          - press twice: STOP
        effect: Stop all audio
''');

    expect(modes, hasLength(1));
    expect(modes.single.name, 'Any Mode');
    final shortcut = modes.single.shortcuts.single;
    expect(shortcut.effect, 'Stop all audio');
    expect(shortcut.condition, isNull);
    final step = shortcut.gesture.single;
    expect(step.action, GestureAction.pressTwice);
    expect(step.control, const SingleControl(Control.stop));
    expect(Control.stop.label, '■');
  });

  test('keeps Modes and Shortcuts in file order, with conditions', () {
    final modes = parseShortcuts('''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture:
          - hold: SHIFT
          - press: PAD BANK
        effect: Select the previous pad bank
      - gesture:
          - hold: TAP TEMPO
          - turn: ENCODER
        effect: Change the tempo
  - mode: Sample Mode
    shortcuts:
      - gesture:
          - hold: ERASE
          - press: any pad
        when: while stopped
        effect: Delete the pad's sample
''');

    expect([for (final mode in modes) mode.name], ['Any Mode', 'Sample Mode']);
    expect(
      [for (final shortcut in modes.first.shortcuts) shortcut.effect],
      ['Select the previous pad bank', 'Change the tempo'],
    );
    final erase = modes.last.shortcuts.single;
    expect(erase.condition, 'while stopped');
    expect(
      [for (final step in erase.gesture) step.action],
      [GestureAction.hold, GestureAction.press],
    );
    expect(
      [for (final step in erase.gesture) step.control],
      [const SingleControl(Control.erase), const AnyPad()],
    );
  });

  test('recognises all eight actions', () {
    final modes = parseShortcuts('''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture:
          - press: SAMPLE
          - press twice: STOP
          - hold: SHIFT
          - release: SHIFT
          - turn: K1
          - press and turn: ENCODER
          - move: FADER
          - tap: pad 5
        effect: Everything at once
''');

    final gesture = modes.single.shortcuts.single.gesture;
    expect([for (final step in gesture) step.action], GestureAction.values);
    expect(gesture.last.control, const Pad(5));
  });

  test('refers to symbol Controls by name and shows their symbol', () {
    final modes = parseShortcuts('''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture:
          - press: PLAY
          - press: MINUS
          - press: PLUS
          - press: B2
        effect: Symbols
''');

    final controls = [
      for (final step in modes.single.shortcuts.single.gesture)
        (step.control as SingleControl).control,
    ];
    expect(
      [for (final control in controls) control.label],
      ['▶', '−', '+', 'B2'],
    );
  });

  group('malformed data names the entry', () {
    void expectError(String yaml, String message) => expect(
      () => parseShortcuts(yaml),
      throwsA(
        isA<ShortcutDataException>().having(
          (error) => error.message,
          'message',
          message,
        ),
      ),
    );

    test('an unknown Control', () {
      expectError('''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture: [press: STOPP]
        effect: Stop
''', 'Mode "Any Mode", Shortcut 1: unknown Control "STOPP"');
    });

    test('an unknown action', () {
      expectError('''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture: [smash: STOP]
        effect: Stop
''', 'Mode "Any Mode", Shortcut 1: unknown action "smash"');
    });

    test('a missing effect', () {
      expectError('''
modes:
  - mode: Sample Mode
    shortcuts:
      - gesture: [press: STOP]
      - gesture: [press: PLAY]
''', 'Mode "Sample Mode", Shortcut 1: missing effect');
    });

    test('an empty Gesture', () {
      expectError('''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture: []
        effect: Nothing
''', 'Mode "Any Mode", Shortcut 1: empty gesture');
    });

    test('a Mode with no name', () {
      expectError('''
modes:
  - mode: Any Mode
    shortcuts: []
  - shortcuts: []
''', 'Mode 2 has no name');
    });

    test('a pad number outside 1–16', () {
      expectError('''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture: [press: pad 17]
        effect: Nothing
''', 'Mode "Any Mode", Shortcut 1: unknown Control "pad 17"');
    });
  });
}
