import 'package:flutter/material.dart';

/// Colours taken from the MPC Sample's screen.
abstract final class DevicePalette {
  static const black = Color(0xFF000000);
  static const nearBlack = Color(0xFF14141A);
  static const darkSurface = Color(0xFF1C1C22);
  static const surface = Color(0xFF282830);
  static const white = Color(0xFFFFFFFF);
  static const mutedWhite = Color(0xFFB4B4BE);
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
  const HelperColors({required this.highlight});

  /// Marks Inexact Positions and the current Q.
  final Color highlight;

  static HelperColors of(BuildContext context) =>
      Theme.of(context).extension<HelperColors>()!;

  /// Text style for Inexact Positions and the current Q.
  TextStyle get highlightStyle =>
      TextStyle(color: highlight, fontWeight: FontWeight.bold);

  @override
  HelperColors copyWith({Color? highlight}) =>
      HelperColors(highlight: highlight ?? this.highlight);

  @override
  HelperColors lerp(HelperColors? other, double t) => other == null
      ? this
      : HelperColors(highlight: Color.lerp(highlight, other.highlight, t)!);
}

/// The app's only theme: always dark, like the device's screen.
///
/// Headings and field labels (the title and label text styles) are amber,
/// so widgets get the colour by using those styles.
ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: DevicePalette.blue,
    onPrimary: DevicePalette.white,
    secondary: DevicePalette.mint,
    onSecondary: DevicePalette.black,
    error: DevicePalette.crimson,
    surface: DevicePalette.black,
    onSurface: DevicePalette.white,
    onSurfaceVariant: DevicePalette.mutedWhite,
    surfaceContainerLowest: DevicePalette.black,
    surfaceContainerLow: DevicePalette.nearBlack,
    surfaceContainer: DevicePalette.darkSurface,
    surfaceContainerHigh: DevicePalette.surface,
    surfaceContainerHighest: DevicePalette.surface,
    outline: DevicePalette.grey,
    outlineVariant: DevicePalette.dimGrey,
  );
  const fieldLabel = InputDecorationTheme(
    labelStyle: TextStyle(color: DevicePalette.amber),
    floatingLabelStyle: TextStyle(color: DevicePalette.amber),
  );

  final base = ThemeData(colorScheme: scheme, fontFamily: 'RobotoMono');
  return base.copyWith(
    scaffoldBackgroundColor: DevicePalette.black,
    dividerColor: DevicePalette.dimGrey,
    textTheme: base.textTheme.copyWith(
      titleMedium: base.textTheme.titleMedium!.copyWith(
        color: DevicePalette.amber,
      ),
      titleSmall: base.textTheme.titleSmall!.copyWith(
        color: DevicePalette.amber,
      ),
      labelSmall: base.textTheme.labelSmall!.copyWith(
        color: DevicePalette.amber,
      ),
    ),
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
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => base.textTheme.labelMedium!.copyWith(
          color: states.contains(WidgetState.selected)
              ? DevicePalette.blue
              : DevicePalette.white,
        ),
      ),
    ),
    inputDecorationTheme: fieldLabel,
    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: fieldLabel,
    ),
    extensions: const [HelperColors(highlight: DevicePalette.crimson)],
  );
}
