# 05: Timeline, zoomed out

**What to build:** Above the Grid Line table on STEP EDIT, a horizontal Timeline whose full width is one Bar, drawn from the `model` layout. Every Beat has a line labelled with its Beat number (1, 2, 3…) along one edge. Every Grid Line has a marker. The four Device Beats appear as faint, unlabelled markers on the opposite edge. The Timeline fits the screen width and labels Grid Lines with their Positions only where the labels won't overlap. Beat labels always show. Inexact Position labels use the highlight colour. The Timeline does no musical arithmetic of its own.

**Blocked by:** 04 (Time Signature emulation and Inexact Positions)

**Status:** ready-for-agent

- [ ] The Timeline fills the available width and represents exactly one Bar
- [ ] Every Beat has a line and its number label, at any Grid Line density
- [ ] Every Grid Line has a marker
- [ ] Faint Device Beat markers appear on the opposite edge from the Beat labels. In 4/4 they line up with the Beats; in 3/4 they don't
- [ ] Grid Line Position labels never overlap. At 1/64 in 4/4 only some are labelled; at 1/4 in 4/4 all are
- [ ] Inexact labels use the highlight colour
- [ ] All positions come from `model`, with no tick arithmetic in the painter
- [ ] Checked by eye in Chrome at 4/4 with 1/16, 3/4 with 1/8T, 7/8 with 1/4, and 4/4 with 1/64, at a phone-like width and at desktop width
- [ ] `flutter test` and `flutter analyze` pass
