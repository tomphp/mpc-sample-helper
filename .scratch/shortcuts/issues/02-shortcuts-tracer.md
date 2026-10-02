# 02: Shortcuts list working, using the five verified Shortcuts

**What to build:** The Shortcuts Tool lists Shortcuts from a YAML data file bundled with the app, grouped under amber Mode headings in file order. Each Shortcut shows its Gesture as plain keycaps joined by `+`. A plain keycap is the Control's label in a simple box, with STOP drawn as `■`. Each keycap has a small amber action word above it. After the keycaps come any condition and then the effect. The intro sentence stays at the top.

The data file starts with the user's five verified Shortcuts:
- press STOP twice;
- hold SAMPLE + press a pad;
- hold SHIFT + press PAD BANK;
- hold TAP TEMPO + turn ENCODER;
- hold TAP TEMPO + press and turn ENCODER.

This ticket adds to `model`:
- the closed set of Controls, with each one's printed label or symbol and its kind;
- the eight actions;
- Gesture steps, conditions and Shortcuts;
- the Mode grouping;
- the entry point, which takes the file's text and returns the Modes, or an error naming the entry and the problem.

`app` loads the asset and renders the result, with no parsing of its own. Uses a pure-Dart YAML parsing dependency. See `.scratch/shortcuts/spec.md`.

**Blocked by:** 01 (Device theme and Roboto Mono)

**Status:** ready-for-agent

- [ ] The data file holds the five verified Shortcuts, under Any Mode and Sample Mode as appropriate
- [ ] `model` covers every MPC Sample Control from the front-panel drawing, each with its label and kind. STOP and PLAY are symbols
- [ ] All eight actions are recognised: press, press twice, hold, release, turn, press and turn, move, tap
- [ ] `model` unit tests:
  - Modes and Shortcuts come back in file order, with steps, conditions and effects intact
  - each of the eight actions is parsed
  - "any pad" resolves
  - errors name the entry for an unknown Control, an unknown action, a missing effect, an empty Gesture, and a Mode with no name
- [ ] A test checks the real bundled data file parses with no errors
- [ ] The Shortcuts Tool shows the intro sentence, then the Mode headings in amber, then each Shortcut's keycaps with action words, `+` between steps, any condition, and the effect
- [ ] Control labels are uppercase as printed. Action words, conditions and effects are normal case
- [ ] An `app` test checks the Tool against a small test data file: the Mode headings are in order, and the keycap labels, action words and effects are shown
- [ ] Checked by eye in Chrome at phone and desktop widths
- [ ] `flutter test` and `flutter analyze` pass
