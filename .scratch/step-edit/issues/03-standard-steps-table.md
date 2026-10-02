# 03: Standard Steps in 4/4 table

**What to build:** At the bottom of STEP EDIT, a table titled "Standard Steps in 4/4" shows the Step in Ticks for every Q value in 4/4, with the column for the current Q value highlighted. The values are always the 4/4 ones, whatever Time Signature is chosen.

**Blocked by:** 02 (Grid Line table in 4/4 with the Q dropdown)

**Status:** ready-for-agent

- [ ] `model` provides the Standard Steps in 4/4: 1/4 = 960, 1/4T = 640, 1/8 = 480, 1/8T = 320, 1/16 = 240, 1/16T = 160, 1/32 = 120, 1/32T = 80, 1/64 = 60
- [ ] The table appears at the bottom of STEP EDIT titled "Standard Steps in 4/4" (normal case)
- [ ] The current Q column uses the theme's highlight colour, and the highlight moves when Q changes
- [ ] A `model` unit test covers the nine values
- [ ] An `app` test checks the table is there and the highlight follows Q
- [ ] `flutter test` and `flutter analyze` pass
