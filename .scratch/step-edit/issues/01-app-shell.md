# 01: App shell with STEP EDIT and Shortcuts tabs

**What to build:** A new Flutter web app called MPC Sample Helper (package `mpc_sample_helper`) that runs locally in a browser and launches on the STEP EDIT Tool. A bottom navigation bar has two Tools, `STEP EDIT` and `Shortcuts`. STEP EDIT is an empty placeholder for now. Shortcuts shows one sentence: "A list of shortcuts that are not labelled on the front panel." The theme defines the single highlight colour that later tickets use for Inexact Positions and the current Q. Set up the two test seams from the spec: `model` (pure Dart, no Flutter imports) and `app` (widget tests that start the whole app). See `.scratch/step-edit/spec.md` and ADR 0001.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] The Flutter project exists with the web target only (no iOS or Android targets) and runs in Chrome via `flutter run -d chrome`
- [ ] The app title is "MPC Sample Helper"
- [ ] The app launches with STEP EDIT selected
- [ ] The bottom navigation bar shows `STEP EDIT` (uppercase) and `Shortcuts` (normal case)
- [ ] Shortcuts shows exactly "A list of shortcuts that are not labelled on the front panel."
- [ ] The theme defines a highlight colour
- [ ] There is a `model` area with no Flutter imports, and an `app` area
- [ ] An `app` widget test checks the launch tab, both navigation labels, and the Shortcuts sentence
- [ ] `flutter test` and `flutter analyze` pass
