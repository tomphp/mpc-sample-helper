import 'package:flutter/material.dart';

/// App colours beyond the Material scheme.
@immutable
class HelperColors extends ThemeExtension<HelperColors> {
  const HelperColors({required this.highlight});

  /// Marks Inexact Positions and the current Q.
  final Color highlight;

  static HelperColors of(BuildContext context) =>
      Theme.of(context).extension<HelperColors>()!;

  @override
  HelperColors copyWith({Color? highlight}) =>
      HelperColors(highlight: highlight ?? this.highlight);

  @override
  HelperColors lerp(HelperColors? other, double t) => other == null
      ? this
      : HelperColors(highlight: Color.lerp(highlight, other.highlight, t)!);
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: brightness,
    ),
    extensions: [
      HelperColors(
        highlight: dark ? Colors.orangeAccent : Colors.deepOrange.shade700,
      ),
    ],
  );
}
