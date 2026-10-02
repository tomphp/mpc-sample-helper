/// What kind of physical input a Control is; decides how it is drawn.
enum ControlKind { button, pad, knob, encoder, fader, functionButton }

/// A physical input on the MPC Sample, as printed on the front panel
/// (User Guide p16). Pads are referred to by number; see [ControlRef].
enum Control {
  sample('SAMPLE'),
  seq('SEQ'),
  padFx('PAD FX'),
  knobFx('KNOB FX'),
  shift('SHIFT'),
  padBank('PAD BANK'),
  erase('ERASE'),
  noteRepeat('NOTE REPEAT'),
  chop('CHOP'),
  mute('MUTE'),
  loop('LOOP'),
  sixteenLevels('16 LEVELS'),
  sampleSelect('SAMPLE SELECT'),
  tapTempo('TAP TEMPO'),
  minus('−', symbolName: 'MINUS'),
  plus('+', symbolName: 'PLUS'),
  sampleRecord('SAMPLE RECORD'),
  seqRecord('SEQ RECORD'),
  stop('■', symbolName: 'STOP'),
  play('▶', symbolName: 'PLAY'),
  k1('K1', kind: ControlKind.knob),
  k2('K2', kind: ControlKind.knob),
  k3('K3', kind: ControlKind.knob),
  mainVolume('MAIN VOLUME', kind: ControlKind.knob),
  encoder('ENCODER', kind: ControlKind.encoder),
  fader('FADER', kind: ControlKind.fader),
  b1('B1', kind: ControlKind.functionButton),
  b2('B2', kind: ControlKind.functionButton),
  b3('B3', kind: ControlKind.functionButton);

  const Control(this.label, {this.symbolName, this.kind = ControlKind.button});

  /// The label or symbol printed on the front panel.
  final String label;

  /// A word for a Control printed as a symbol (e.g. STOP for ■).
  final String? symbolName;

  final ControlKind kind;

  /// The name the Shortcut data file uses for this Control: its label,
  /// or a word for those printed as symbols.
  String get reference => symbolName ?? label;

  static Control? byReference(String reference) {
    for (final control in values) {
      if (control.reference == reference) return control;
    }
    return null;
  }
}

/// Which Control (or pad) a Gesture step acts on.
sealed class ControlRef {
  const ControlRef();
}

class SingleControl extends ControlRef {
  const SingleControl(this.control);

  final Control control;

  @override
  bool operator ==(Object other) =>
      other is SingleControl && other.control == control;

  @override
  int get hashCode => control.hashCode;

  @override
  String toString() => control.reference;
}

/// One numbered pad, 1–16.
class Pad extends ControlRef {
  const Pad(this.number);

  final int number;

  @override
  bool operator ==(Object other) => other is Pad && other.number == number;

  @override
  int get hashCode => number.hashCode;

  @override
  String toString() => 'pad $number';
}

/// Whichever pad the user chooses.
class AnyPad extends ControlRef {
  const AnyPad();

  @override
  bool operator ==(Object other) => other is AnyPad;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'any pad';
}
