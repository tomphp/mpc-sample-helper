/// What kind of physical input a Control is; decides how it is drawn.
enum ControlKind { button, pad, knob, encoder, fader, functionButton }

/// A button's body colour on the front panel.
enum ButtonColour { grey, blue, orange }

/// The coloured bar printed on record and transport buttons.
enum ButtonStripe { red, white, green }

/// A physical input on the MPC Sample, as printed on the front panel
/// (User Guide p16). Pads are referred to by number; see [ControlRef].
enum Control {
  sample('SAMPLE'),
  seq('SEQ'),
  padFx('PAD FX', colour: ButtonColour.orange),
  knobFx('KNOB FX', colour: ButtonColour.orange),
  shift('SHIFT'),
  padBank('PAD BANK'),
  erase('ERASE'),
  noteRepeat('NOTE REPEAT'),
  chop('CHOP', colour: ButtonColour.blue),
  mute('MUTE', colour: ButtonColour.blue),
  loop('LOOP', colour: ButtonColour.blue),
  sixteenLevels('16 LEVELS', colour: ButtonColour.blue),
  sampleSelect('SAMPLE SELECT'),
  tapTempo('TAP TEMPO'),
  minus('−', symbolName: 'MINUS'),
  plus('+', symbolName: 'PLUS'),
  sampleRecord('SAMPLE RECORD', stripe: ButtonStripe.red),
  seqRecord('SEQ RECORD', stripe: ButtonStripe.red),
  stop('■', symbolName: 'STOP', stripe: ButtonStripe.white),
  play('▶', symbolName: 'PLAY', stripe: ButtonStripe.green),
  k1('K1', kind: ControlKind.knob),
  k2('K2', kind: ControlKind.knob),
  k3('K3', kind: ControlKind.knob),
  mainVolume('MAIN VOLUME', kind: ControlKind.knob),
  encoder('ENCODER', kind: ControlKind.encoder),
  fader('FADER', kind: ControlKind.fader),
  b1('B1', kind: ControlKind.functionButton),
  b2('B2', kind: ControlKind.functionButton),
  b3('B3', kind: ControlKind.functionButton);

  const Control(
    this.label, {
    this.symbolName,
    this.kind = ControlKind.button,
    this.colour = ButtonColour.grey,
    this.stripe,
  });

  /// The label or symbol printed on the front panel.
  final String label;

  /// A word for a Control printed as a symbol (e.g. STOP for ■).
  final String? symbolName;

  final ControlKind kind;

  /// For buttons: the body colour on the front panel.
  final ButtonColour colour;

  /// For buttons: the coloured bar printed on it, if any.
  final ButtonStripe? stripe;

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

/// A run of numbered pads, e.g. pads 1–8.
class PadRange extends ControlRef {
  const PadRange(this.first, this.last);

  final int first;
  final int last;

  @override
  bool operator ==(Object other) =>
      other is PadRange && other.first == first && other.last == last;

  @override
  int get hashCode => Object.hash(first, last);

  @override
  String toString() => 'pads $first–$last';
}

/// Any one of several Controls, e.g. K1 / K2 / K3.
class ControlChoice extends ControlRef {
  const ControlChoice(this.options);

  final List<ControlRef> options;

  @override
  bool operator ==(Object other) =>
      other is ControlChoice &&
      other.options.length == options.length &&
      other.options.indexed.every((entry) => options[entry.$1] == entry.$2);

  @override
  int get hashCode => Object.hashAll(options);

  @override
  String toString() => options.join(' / ');
}
