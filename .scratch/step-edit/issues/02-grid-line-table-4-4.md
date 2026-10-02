# 02: Grid Line table in 4/4 with the Q dropdown

**What to build:** On STEP EDIT, the user picks a Quantize value from a dropdown labelled `Q` and sees a table listing every Grid Line in one 4/4 Bar. Each row shows the Grid Line number, its Position (`beat:tick`, e.g. `1:240`) and the Beat number when the Grid Line lands on a Beat. For now the Time Signature is fixed at 4/4, so every Position is exact. This ticket starts the `model` module: the Q values, a Time Signature value, the layout entry point, and the Position value with its display format. Use exact fractions, not floating point. See the spec's Implementation Decisions for the emulation rule and the Position format.

**Blocked by:** 01 (App shell with STEP EDIT and Shortcuts tabs)

**Status:** ready-for-agent

- [x] The `Q` dropdown offers 1/4, 1/4T, 1/8, 1/8T, 1/16, 1/16T, 1/32, 1/32T and 1/64, all shown the same way, defaulting to 1/16
- [x] `model` takes a Time Signature and a Q value and returns the Grid Lines (number from 1, fraction of the Bar, Position, Beat number if on a Beat), the Beats and the four Device Beats
- [x] The Bar is 3840 Ticks and the Step is 3840 × note value ÷ (beats × n), times 2/3 for triplets
- [x] Positions are written `beat:tick`, Device Beat counted from 1, Tick padded to three digits (`1:000`, `1:080`)
- [x] The table has Grid Line number, Position and Beat columns
- [x] `model` unit tests, all in 4/4: 1/16 gives 16 Grid Lines `1:000` to `4:720`; 1/4T gives 6 Grid Lines ending at `4:320`; 1/4 gives Beat numbers 1–4; every Q value is exact
- [x] An `app` test checks the table starts `1:000`, `1:240` by default and updates when Q changes
- [x] `flutter test` and `flutter analyze` pass
