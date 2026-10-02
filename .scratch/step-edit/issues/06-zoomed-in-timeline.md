# 06: Zoomed-in Timeline and the zoom button

**What to build:** A button on STEP EDIT switches the Timeline between the zoomed-out view (the default, from ticket 05) and a zoomed-in view. The zoomed-in view gives each Grid Line enough width for its Position label, labels every Grid Line, and scrolls sideways. The Grid Line table stays under the Timeline in both views.

**Blocked by:** 05 (Timeline, zoomed out)

**Status:** ready-for-agent

- [x] A button switches between the zoomed-out and zoomed-in Timeline. Zoomed out is the default
- [x] Zoomed in, every Grid Line's Position is labelled without overlap, and the Timeline scrolls sideways
- [x] Beat lines, Beat labels, Device Beat markers and Inexact highlighting work the same in both views
- [x] The Grid Line table shows in both views
- [x] An `app` test checks that the button switches views and the table is still there
- [x] Checked by eye in Chrome at 4/4 with 1/64 and at 16/8 with 1/32T
- [x] `flutter test` and `flutter analyze` pass
