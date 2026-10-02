# 07: Real Time Signatures

**What to build:** Replace the 4/4 emulation with the device's real Time Signatures (ADR 0003, superseding ADR 0002).

One dropdown labelled "Time Signature" offers exactly these values, in this order: 2/4, 3/4, 4/4, 5/4, 6/4, 7/4, 6/8, 7/8, 9/8, 10/8, 11/8, 12/8. It defaults to 4/4.

A Bar is its real length: Beats × Ticks per Beat, where a Beat is 960 Ticks in x/4 and 480 in x/8. Positions are `beat:tick` with the left number counting Beats of the Time Signature. In 6/8 with Q at 1/16, the Positions are `1:000`, `1:240`, `2:000` … `6:240`.

Quantize is independent of the Time Signature (1/16 is always 240 Ticks). Every Position is therefore a whole number of Ticks, so Inexact Positions, the Device Bar and Device Beats are removed.

The Timeline still stretches every Bar to full width and draws every Beat the same, with no compound grouping. When Q doesn't divide the Bar evenly, Grid Lines still sit where they fall and leave a short final gap. For example, 7/8 with 1/4 gives `1:000`, `3:000`, `5:000`, `7:000`.

**Blocked by:** none

**Status:** ready-for-agent

- [x] `TimeSignature` is an enum of exactly the twelve listed values, in order. `beatChoices` and `noteValueChoices` are removed
- [x] STEP EDIT shows one "Time Signature" dropdown in place of the Beats and Note value dropdowns
- [x] `layoutBar` uses the real Bar length. Beat length is 3840 ÷ note value, and the Step for Q = 1/n is 3840 ÷ n (× 2/3 for triplets)
- [x] `Position` counts Beats of the Time Signature (Ticks per Beat comes from the note value) and holds a whole-number Tick. Rounding, the 960 carry, the decimal display and `isInexact` are removed. `Fraction` is removed: every Step is a whole number of Ticks
- [x] `BarLayout.deviceBeats` and the Timeline's Device Beat markers are removed
- [x] Inexact highlighting is removed from the Timeline labels and the Grid Line table. The highlight colour stays for the current Q column
- [x] The "Standard Steps in 4/4" table is retitled "Steps" (it holds for every Time Signature)
- [x] `model` unit tests:
  - 4/4 with 1/16 gives `1:000`, `1:240` … `4:720` (unchanged)
  - 3/4 with 1/4 gives `1:000`, `2:000`, `3:000`, with Beats 1–3
  - 6/8 with 1/16 gives 12 Grid Lines, `1:000`, `1:240`, `2:000` … `6:240`, with a Beat on every other line
  - 7/8 with 1/4 gives `1:000`, `3:000`, `5:000`, `7:000` with a short final gap
  - 12/8 with 1/8T gives `1:000`, `1:320`, `2:160`, `3:000` …
  - 2/4 and 12/8 edges. Removed tests: Inexact Positions, the 960 carry, the 1/4, 5/8 and 16/8 edges
  - The Time Signatures are exactly the twelve values, in order
- [x] `app` test: switching to 6/8 shows `6:240` in the table; the dropdown lists exactly the twelve values
- [x] Checked by eye (rendered from a widget test) at 6/8 with 1/16, 7/8 with 1/4, and 12/8 with 1/64 zoomed in
- [x] `flutter test` and `flutter analyze` pass
