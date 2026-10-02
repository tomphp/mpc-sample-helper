# 03: Keycaps that look like the device, plus ranges and choices

**What to build:** Every keycap is drawn like the real Control:
- **Buttons** are rounded rectangles with white uppercase labels.
  - Most are grey `#85898A`.
  - CHOP, MUTE, LOOP and 16 LEVELS are blue `#0191DA`.
  - PAD FX and KNOB FX are orange `#FF5001`.
  - SAMPLE RECORD and SEQ RECORD have a red bar.
  - STOP is `■` with a white bar, and PLAY is `▶` with a green bar.
- **Pads** are grey squares with a navy edge and their number.
- **K1–K3 and the ENCODER** are small knob icons with their label.
- **B1–B3** are small dark pills.
- **The fader** is drawn as a fader.

The data file and `model` also gain:
- **pad ranges**, e.g. pads 1–8, drawn as a range;
- **choices of Controls**, e.g. K1 / K2 / K3, drawn as alternatives.

Colours and labels come from the front-panel drawing in the User Guide. See `.scratch/shortcuts/spec.md`.

**Blocked by:** 02 (Shortcuts list working, using the five verified Shortcuts)

**Status:** ready-for-agent

- [ ] Each Control in `model` knows its colour group (grey, blue or orange, plus a red record bar, a white STOP bar or a green PLAY bar), and its kind decides how its keycap is drawn
- [ ] `model` parses pad ranges and choices of Controls. Unit tests cover pads 1–8, K1 / K2 / K3, B1 / B2 / B3, and the errors for a malformed range or choice
- [ ] Keycaps are drawn as described for every kind: buttons in each colour group, record bars, STOP, PLAY, pads, any pad, pad ranges, knobs, the ENCODER, B1–B3, the fader, and choices
- [ ] The `app` test from 02 still passes, with keycap labels still findable as text
- [ ] Checked by eye in Chrome with a test data file that includes every keycap kind, at phone and desktop widths
- [ ] `flutter test` and `flutter analyze` pass
