import 'package:flutter/material.dart';

/// Colours taken from the MPC Sample's screen.
abstract final class DevicePalette {
  static const black = Color(0xFF000000);
  static const surface = Color(0xFF282830);
  static const white = Color(0xFFFFFFFF);
  static const amber = Color(0xFFF8B800);
  static const crimson = Color(0xFFD81048);
  static const blue = Color(0xFF2F9BFF);
  static const mint = Color(0xFF00FCA8);
  static const grey = Color(0xFF8A8A94);
  static const dimGrey = Color(0xFF3A3A44);
}

/// App colours beyond the Material scheme.
@immutable
class HelperColors extends ThemeExtension<HelperColors> {
  const HelperColors({required this.highlight, required this.label});

  /// Marks Inexact Positions and the current Q.
  final Color highlight;

  /// Field labels and headings.
  final Color label;

  static HelperColors of(BuildContext context) =>
      Theme.of(context).extension<HelperColors>()!;

  /// Text style for Inexact Positions and the current Q.
  TextStyle get highlightStyle =>
      TextStyle(color: highlight, fontWeight: FontWeight.bold);

  @override
  HelperColors copyWith({Color? highlight, Color? label}) => HelperColors(
    highlight: highlight ?? this.highlight,
    label: label ?? this.label,
  );

  @override
  HelperColors lerp(HelperColors? other, double t) => other == null
      ? this
      : HelperColors(
          highlight: Color.lerp(highlight, other.highlight, t)!,
          label: Color.lerp(label, other.label, t)!,
        );
}

/// The app's only theme: always dark, like the device's screen.
ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: DevicePalette.blue,
    onPrimary: DevicePalette.white,
    secondary: DevicePalette.mint,
    onSecondary: DevicePalette.black,
    error: DevicePalette.crimson,
    surface: DevicePalette.black,
    onSurface: DevicePalette.white,
    onSurfaceVariant: Color(0xFFB4B4BE),
    surfaceContainerLowest: DevicePalette.black,
    surfaceContainerLow: Color(0xFF14141A),
    surfaceContainer: Color(0xFF1C1C22),
    surfaceContainerHigh: DevicePalette.surface,
    surfaceContainerHighest: DevicePalette.surface,
    outline: DevicePalette.grey,
    outlineVariant: DevicePalette.dimGrey,
  );
  const labelStyle = TextStyle(color: DevicePalette.amber);

  return ThemeData(
    colorScheme: scheme,
    fontFamily: 'RobotoMono',
    scaffoldBackgroundColor: DevicePalette.black,
    dividerColor: DevicePalette.dimGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: DevicePalette.black,
      foregroundColor: DevicePalette.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: DevicePalette.surface,
      indicatorColor: DevicePalette.mint,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? DevicePalette.black
              : DevicePalette.white,
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: labelStyle,
      floatingLabelStyle: labelStyle,
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: labelStyle,
        floatingLabelStyle: labelStyle,
      ),
    ),
    extensions: const [
      HelperColors(
        highlight: DevicePalette.crimson,
        label: DevicePalette.amber,
      ),
    ],
  );
}
