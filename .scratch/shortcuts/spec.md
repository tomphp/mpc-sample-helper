# Spec: MPC Sample Helper — Shortcuts Tool and device styling

Status: ready-for-agent

## Problem Statement

The MPC Sample has many useful Shortcuts: Gestures on its Controls whose effect is printed on the front panel neither as a Control's label nor as its Shift Label. Pressing STOP twice to stop all audio, holding SAMPLE and pressing a pad to select it without playing it, and SHIFT + PAD BANK for the previous pad bank are examples. Users only find them by reading a 67-page manual or by accident, and many only apply in one Mode. The app currently has a placeholder Shortcuts Tool. It also doesn't look like the device it supports.

## Solution

The Shortcuts Tool lists the Shortcuts grouped by Mode. Each Gesture is drawn as keycaps that look like the real Controls, with small action words above them, followed by the effect. The list comes from a data file bundled with the app that the user can edit directly.

The whole app takes on the look of the MPC Sample's screen. It is always dark, uses the device's colours, and uses a monospaced font.

## User Stories

### Device styling

1. As an MPC Sample user, I want the app to look like my device's screen, so that it feels like part of the instrument.
2. As an MPC Sample user, I want the app always dark, even when my system is set to light, so that it matches the device.
3. As an MPC Sample user, I want a black background with `#282830` surfaces and white text, so that the app reads like the device display.
4. As an MPC Sample user, I want field labels and Mode headings in amber (`#F8B800`), so that they stand out the way names do on the device.
5. As an MPC Sample user, I want Inexact Positions and the current Q highlighted in crimson (`#D81048`), so that warnings use the device's warning colour.
6. As an MPC Sample user, I want the active value and the selected tab in blue, so that selection looks like it does on the device.
7. As an MPC Sample user, I want mint (`#00FCA8`) as the accent, e.g. the bottom bar's selected-tab marker, so that the app shares the device's accent.
8. As an MPC Sample user, I want the Timeline drawn as a dark grey Bar with white Beat lines, so that it fits the dark theme.
9. As an MPC Sample user, I want the whole app in Roboto Mono, so that it resembles the device's monospaced screen font.
10. As an MPC Sample user, I want the font bundled with the app, so that it works offline and fetches nothing at runtime.
11. As an MPC Sample user, I want STEP EDIT to keep its Position format (`2:320`), so that only the look changes.

### Shortcuts list

12. As an MPC Sample user, I want the Shortcuts Tool to keep its intro sentence "A list of shortcuts that are not labelled on the front panel.", so that I know what the list covers.
13. As an MPC Sample user, I want Shortcuts grouped under Mode headings (e.g. Any Mode, Sample Mode, Sequence Mode, Step Edit, Chop Mode), so that I can find the ones for what I'm doing.
14. As an MPC Sample user, I want the Modes in the same order as in the data file, so that the author controls the order.
15. As an MPC Sample user, I want each Shortcut's effect in plain, normal-case words, so that I know what it does.
16. As an MPC Sample user, I want a condition such as "while stopped" or "during playback" shown with the Gesture, so that I know when it works.
17. As an MPC Sample user, I want the same Gesture listed separately under each Mode where it does something different (e.g. hold ERASE + press a pad), so that I'm not misled.

### Keycaps

18. As an MPC Sample user, I want each step of a Gesture drawn as a keycap that looks like the real Control, so that I can find it on the device at a glance.
19. As an MPC Sample user, I want buttons drawn as rounded rectangles with white uppercase labels, so that they look like the device's buttons.
20. As an MPC Sample user, I want most buttons grey (`#85898A`), CHOP, MUTE, LOOP and 16 LEVELS blue (`#0191DA`), and PAD FX and KNOB FX orange (`#FF5001`), so that the colours match the device.
21. As an MPC Sample user, I want SAMPLE RECORD and SEQ RECORD drawn with their red bar, so that they look like the device's record buttons.
22. As an MPC Sample user, I want STOP drawn as `■` with a white bar and PLAY as `▶` with a green bar, so that they match the unlabelled transport buttons.
23. As an MPC Sample user, I want pads drawn as grey squares with a navy edge and their number, so that I can tell which pad to press.
24. As an MPC Sample user, I want a range of pads (e.g. pad 1–8) and an unnumbered "a pad" drawn clearly, so that I know whether a specific pad matters.
25. As an MPC Sample user, I want K1–K3 and the ENCODER drawn as small knob icons with their label, so that I can tell knobs from buttons.
26. As an MPC Sample user, I want B1–B3 drawn as small dark pills, so that they look like the function buttons above the screen.
27. As an MPC Sample user, I want a choice of Controls (e.g. K1 / K2 / K3) drawn as alternatives, so that I know any one of them works.
28. As an MPC Sample user, I want the action (hold, press, ×2, turn, press and turn, release, move, tap) shown in small amber text above each keycap, so that I know what to do with each Control.
29. As an MPC Sample user, I want the steps of a Gesture joined by `+` in order, so that I can follow the sequence.
30. As an MPC Sample user, I want only labels printed on the device in uppercase, so that the casing rule holds across the app.

### Shortcut data

31. As the author, I want Shortcuts kept in a structured data file bundled with the app, so that I can add, remove or reword them without touching code.
32. As the author, I want each entry to hold a Mode, the Gesture's ordered steps, an optional condition and an effect, so that keycaps are drawn from structure rather than parsed from prose.
33. As the author, I want a clear error naming the entry and field when the file is malformed (e.g. an unknown Control or action), so that I can fix my edits quickly.
34. As the author, I want a test that fails when the bundled data file doesn't parse, so that a bad edit can't ship.
35. As the author, I want the data file's initial contents to come from my edited candidates list, so that only Shortcuts I've chosen appear.

## Implementation Decisions

- **Theme:**
  - A single dark theme replaces the current light and dark themes. The app ignores the system brightness.
  - The palette is the device-screen colours above, kept in one place in the theme. The existing highlight colour becomes the crimson, so STEP EDIT's highlighting is unchanged in behaviour.
  - Roboto Mono is bundled as a font asset and set as the app-wide font family. No runtime font fetching.
- **Shortcut data file:**
  - A YAML asset bundled with the app, listing Modes in order. Each Mode has a name and its Shortcuts.
  - Each Shortcut has its Gesture's steps, an optional condition and an effect.
  - Each step has an action and a Control reference. The reference can be a single Control, a pad range (e.g. pads 1–8, or any pad) or a choice of Controls (e.g. K1 / K2 / K3).
  - Adds a pure-Dart YAML parsing dependency.
- **`model` additions (pure Dart, no Flutter imports):**
  - **Control:** a closed set of the MPC Sample's Controls, each knowing its printed label (or symbol, for STOP and PLAY) and its kind: button, pad, knob, ENCODER, fader or function button. Buttons also know their colour group: grey, blue or orange, plus a red record bar, a white bar for STOP or a green bar for PLAY. Labels and colours come from the front-panel drawing in the User Guide.
  - **Gesture step:** an action and a Control reference. The actions are press, press twice, hold, release, turn, press and turn, move and tap.
  - **Shortcut:** a Gesture (ordered steps), an optional condition and an effect.
  - **Mode grouping:** an ordered list of Modes, each with its Shortcuts.
  - **The single entry point** takes the data file's text and returns the Mode grouping. It fails with an error naming the entry and the problem when the text is malformed.
- **`app` additions:**
  - Loads the bundled data file and passes its text to `model`.
  - A keycap widget draws one Gesture step: an amber action word above a drawing of the Control, styled from the Control's kind and colour group.
  - The Shortcuts Tool renders the intro sentence, then each Mode heading in amber, then its Shortcuts. Each Shortcut shows its keycaps joined by `+`, the condition and the effect.
  - It does no parsing or Control lookup of its own.
- **Data entry:** the initial data file is written from the user's edited `.scratch/shortcuts/candidates.md`. That ticket waits until the user has finished editing it. Manual page numbers are not carried over.
- **Casing rule:** device labels (Control labels, `STEP EDIT`, `Q`) are uppercase; all other text is normal case.

## Testing Decisions

- **Good tests check behaviour you can see from outside.** That means what `model` returns for a given data file, and what a user sees in the running app. They don't depend on widget tree structure or painting details.
- **Seam `model` (most tests):** feed small YAML strings to the entry point.
  - **Modes and Shortcuts come back in file order**, with steps, conditions and effects intact.
  - **Each Control reference resolves:**
    - a single button, e.g. SAMPLE;
    - STOP and PLAY as symbols;
    - a pad range, pads 1–8;
    - any pad;
    - a choice, K1 / K2 / K3;
    - the ENCODER;
    - the fader;
    - B1–B3.
  - **All eight actions are recognised.**
  - **Malformed input produces an error that names the entry:**
    - an unknown Control;
    - an unknown action;
    - a missing effect;
    - an empty Gesture;
    - a Mode with no name.
  - **The real bundled data file parses with no errors.**
- **Seam `app` (a few tests):**
  - The app's theme is dark even when the platform brightness is light, and uses Roboto Mono.
  - The Shortcuts Tool, given a small test data file, shows its intro sentence, the Mode headings in order, and each Shortcut's keycap labels, action words and effect.
  - The existing STEP EDIT tests keep passing; their highlight checks read the colour from the theme.
- **Checked by eye (headless Chrome screenshots, as for the Timeline):**
  - the palette across STEP EDIT and Shortcuts;
  - each kind of keycap (grey, blue and orange buttons, record bars, STOP, PLAY, pads, pad ranges, knobs, ENCODER, B1–B3, choices);
  - phone and desktop widths.
- **Prior art:** the existing `model` unit tests (Position, bar layout, Standard Steps) and the `app` widget tests that start the whole app.

## Out of Scope

- Search or filtering of Shortcuts.
- Manual page numbers in the app.
- Changing STEP EDIT's Position format or behaviour.
- A light theme, or following the system brightness.
- Editing Shortcuts from inside the app.
- Phone app builds and public hosting.

## Further Notes

- Glossary terms used: Shortcut, Gesture, Control, Shift Label, Mode (see `CONTEXT.md`).
- Source: Akai MPC Sample User Guide v1.0 (front-panel drawing p16; Shortcut candidates throughout, pages listed in the candidates file). The colours are approximations taken from the manual's illustrations, not from product photos.
- The user verified these on the device: STOP twice, hold SAMPLE + pad, SHIFT + PAD BANK, hold TAP TEMPO + turn ENCODER, and hold TAP TEMPO + press and turn ENCODER for decimals. The manual doesn't document the last one.
