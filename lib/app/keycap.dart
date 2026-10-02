import 'package:flutter/material.dart';

import '../model/model.dart';
import 'theme.dart';

/// One Gesture step: the action in small amber text above a drawing of the
/// Control.
class Keycap extends StatelessWidget {
  const Keycap({super.key, required this.step});

  final GestureStep step;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          step.action.word,
          style: textTheme.labelSmall!.copyWith(
            color: HelperColors.of(context).label,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: DevicePalette.grey),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(_label(step.control), style: textTheme.labelLarge),
        ),
      ],
    );
  }

  static String _label(ControlRef control) => switch (control) {
    SingleControl(:final control) => control.label,
    Pad(:final number) => 'pad $number',
    AnyPad() => 'pad',
  };
}
