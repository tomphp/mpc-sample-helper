# 01: Device theme and Roboto Mono

**What to build:** The whole app takes on the look of the MPC Sample's screen, and is always dark whatever the system brightness. Palette:
- black background, `#282830` surfaces, white text;
- amber `#F8B800` for field labels and headings;
- crimson `#D81048` as the highlight, for Inexact Positions and the current Q;
- blue for the active value and the selected tab;
- mint `#00FCA8` as the accent, e.g. the bottom bar's selected-tab marker.

Roboto Mono is bundled as a font asset and used everywhere, with no runtime fetching. STEP EDIT is restyled to match: the Timeline is a dark grey Bar with white Beat lines. Its behaviour and Position format don't change. See `.scratch/shortcuts/spec.md`.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] One dark theme replaces the light and dark themes. The app is dark even when the platform brightness is light
- [ ] The palette above is defined in one place in the theme, and the highlight is the crimson
- [ ] Roboto Mono is bundled (with its licence) and set as the app-wide font
- [ ] Field labels are amber, and the bottom bar's selected tab uses the mint accent
- [ ] The Timeline uses a dark grey Bar with white Beat lines. Inexact labels are crimson
- [ ] An `app` test checks the theme is dark under light platform brightness and uses Roboto Mono
- [ ] STEP EDIT's existing `app` tests pass unchanged
- [ ] Checked by eye in Chrome at phone and desktop widths: STEP EDIT at 3/4 with 1/8T (zoomed out and in), and the Shortcuts Tool
- [ ] `flutter test` and `flutter analyze` pass
