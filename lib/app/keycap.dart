import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../model/model.dart';
import 'theme.dart';

/// Front-panel colours from the User Guide's hardware drawing.
abstract final class _Panel {
  static const greyButton = Color(0xFF85898A);
  static const blueButton = Color(0xFF0191DA);
  static const orangeButton = Color(0xFFFF5001);
  static const redStripe = Color(0xFFCD1433);
  static const greenStripe = Color(0xFF64BB46);
  static const pad = Color(0xFF85898A);
  static const padWell = Color(0xFF22314E);
  static const knob = Color(0xFF3A3D44);
  static const functionButton = Color(0xFF2C2C34);
}

/// One Gesture step: the action in small amber text above a drawing of the
/// Control.
class Keycap extends StatelessWidget {
  const Keycap({super.key, required this.step});

  final GestureStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          step.action.word,
          style: Theme.of(context).textTheme.labelSmall!
              .copyWith(color: HelperColors.of(context).label),
        ),
        const SizedBox(height: 4),
        _ControlDrawing(step.control),
      ],
    );
  }
}

class _ControlDrawing extends StatelessWidget {
  const _ControlDrawing(this.control);

  final ControlRef control;

  @override
  Widget build(BuildContext context) => switch (control) {
    SingleControl(:final control) => switch (control.kind) {
      ControlKind.button => _Button(control),
      ControlKind.knob => _Knob(control.label),
      ControlKind.encoder => _Knob(control.label, encoder: true),
      ControlKind.fader => _Fader(control.label),
      ControlKind.functionButton => _FunctionButton(control.label),
      ControlKind.pad => _Pad(label: control.label),
    },
    Pad(:final number) => _Pad(label: '$number'),
    AnyPad() => const _Pad(label: 'any'),
    PadRange(:final first, :final last) => _Pad(label: '$first–$last'),
    ControlChoice(:final options) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, option) in options.indexed) ...[
          if (index > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('/'),
            ),
          _ControlDrawing(option),
        ],
      ],
    ),
  };
}

const _labelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 12,
);

/// A rounded button in its front-panel colour, with any stripe beneath its
/// label.
class _Button extends StatelessWidget {
  const _Button(this.control);

  final Control control;

  @override
  Widget build(BuildContext context) {
    final stripe = switch (control.stripe) {
      ButtonStripe.red => _Panel.redStripe,
      ButtonStripe.white => Colors.white,
      ButtonStripe.green => _Panel.greenStripe,
      null => null,
    };
    return Container(
      constraints: const BoxConstraints(minWidth: 44, minHeight: 34),
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 5),
      decoration: BoxDecoration(
        color: switch (control.colour) {
          ButtonColour.grey => _Panel.greyButton,
          ButtonColour.blue => _Panel.blueButton,
          ButtonColour.orange => _Panel.orangeButton,
        },
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black54, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(control.label, style: _labelStyle),
          if (stripe != null) ...[
            const SizedBox(height: 3),
            Container(width: 28, height: 4, color: stripe),
          ],
        ],
      ),
    );
  }
}

/// A grey pad in its navy well, numbered in the corner like the device.
class _Pad extends StatelessWidget {
  const _Pad({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _Panel.padWell,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: _Panel.pad,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          label,
          style: _labelStyle.copyWith(fontSize: label.length > 2 ? 9 : 11),
        ),
      ),
    );
  }
}

/// K1–K3 as small knobs, the ENCODER as a larger knurled one.
class _Knob extends StatelessWidget {
  const _Knob(this.label, {this.encoder = false});

  final String label;
  final bool encoder;

  @override
  Widget build(BuildContext context) {
    final size = encoder ? 30.0 : 24.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size.square(size),
          painter: _KnobPainter(encoder: encoder),
        ),
        const SizedBox(width: 6),
        Text(label, style: _labelStyle),
      ],
    );
  }
}

class _KnobPainter extends CustomPainter {
  const _KnobPainter({required this.encoder});

  final bool encoder;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final radius = size.width / 2;
    canvas.drawCircle(centre, radius, Paint()..color = _Panel.knob);
    final rim = Paint()
      ..color = _Panel.greyButton
      ..style = PaintingStyle.stroke
      ..strokeWidth = encoder ? 3 : 1.5;
    canvas.drawCircle(centre, radius - rim.strokeWidth / 2, rim);
    if (encoder) {
      // Knurling: short ticks round the rim.
      final tick = Paint()
        ..color = _Panel.knob
        ..strokeWidth = 1;
      for (var i = 0; i < 24; i++) {
        final direction = Offset.fromDirection(i * 2 * math.pi / 24);
        canvas.drawLine(
          centre + direction * (radius - 3),
          centre + direction * radius,
          tick,
        );
      }
    } else {
      canvas.drawLine(
        centre,
        centre - Offset(0, radius - 3),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_KnobPainter old) => old.encoder != encoder;
}

/// The fader: a slot with a grey cap.
class _Fader extends StatelessWidget {
  const _Fader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _Panel.functionButton,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Container(
            width: 16,
            height: 9,
            decoration: BoxDecoration(
              color: _Panel.greyButton,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: _labelStyle),
      ],
    );
  }
}

/// B1–B3: the small pills above the screen.
class _FunctionButton extends StatelessWidget {
  const _FunctionButton(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _Panel.functionButton,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _Panel.greyButton),
      ),
      child: Text(label, style: _labelStyle),
    );
  }
}
