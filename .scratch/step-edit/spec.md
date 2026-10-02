# Spec: MPC Sample Helper — STEP EDIT Tool

Status: ready-for-agent

## Problem Statement

MPC Sample users place events in Step Edit by typing a Position (Device Beat and Tick, e.g. `2:320`). Working out which Position corresponds to a given Grid Line means doing arithmetic in Ticks (960 per Device Beat) in their head. It gets harder when they want a Time Signature other than 4/4: the device only supports 4/4, so users fake other Time Signatures by spreading the Beats across a 4/4 Device Bar, and the resulting Positions are unintuitive and often not whole Ticks (e.g. 3/4 puts Beat 2 at `2:320`; 3/4 with 1/8T puts a Grid Line at `1:426.7`).

## Solution

MPC Sample Helper is a Flutter web app (runnable locally in a browser) made of Tools on a bottom navigation bar. Its first Tool, **STEP EDIT**, lets the user pick a Time Signature and a Quantize (`Q`) value and shows:

- A Timeline representing one Bar, with every Beat drawn and numbered, every Grid Line marked, and the Device Beats shown faintly.
- A table listing every Grid Line's Position, with Inexact Positions highlighted.
- A "Standard Steps in 4/4" reference table showing the Step for every Q value in 4/4.

A second Tool, **Shortcuts**, is a placeholder with one intro sentence, so the navigation bar has two destinations.

## User Stories

### Navigation

1. As an MPC Sample user, I want the app to open on the STEP EDIT Tool, so that I can get to the Positions immediately.
2. As an MPC Sample user, I want a bottom navigation bar with STEP EDIT and Shortcuts, so that I can move between Tools.
3. As an MPC Sample user, I want the Shortcuts Tool to show the sentence "A list of shortcuts that are not labelled on the front panel.", so that I know what the Tool will hold.
4. As an MPC Sample user, I want labels that appear on the device (`STEP EDIT`, `Q`) in uppercase and every other label in normal case, so that I can tell which labels I'll find on the device.

### Choosing settings

5. As an MPC Sample user, I want to choose the Time Signature with two dropdowns, beats from 1 to 16 and a note value of 4 or 8, so that I can emulate the meter I'm writing in.
6. As an MPC Sample user, I want the Time Signature to default to 4/4, so that the most common case needs no setup.
7. As an MPC Sample user, I want to choose Quantize from a dropdown labelled `Q`, so that it matches the label on my device.
8. As an MPC Sample user, I want Q to offer 1/4, 1/4T, 1/8, 1/8T, 1/16, 1/16T, 1/32, 1/32T and 1/64, so that I can explore every common grid, including ones the device doesn't offer itself.
9. As an MPC Sample user, I want Q to default to 1/16, so that the most common MPC grid is shown first.
10. As an MPC Sample user, I want every view to update immediately when I change the Time Signature or Q, so that I can compare settings quickly.

### Positions

11. As an MPC Sample user, I want every Position shown as Device Beat and Tick (e.g. `2:320`), so that I can type it straight into Step Edit.
12. As an MPC Sample user, I want the Bar to always fill one 4/4 Device Bar of 3840 Ticks, whatever Time Signature I choose, so that the Positions match how I emulate that Time Signature on the device.
13. As an MPC Sample user choosing 3/4 with Q at 1/4, I want to see Positions `1:000`, `2:320` and `3:640`, so that I can place each Beat of my emulated 3/4 Bar.
14. As an MPC Sample user, I want Positions that aren't whole Ticks rounded to one decimal place, so that I know the closest value I can enter.
15. As an MPC Sample user, I want whole-Tick Positions shown without a decimal point, so that exact values look exact.
16. As an MPC Sample user, I want Inexact Positions shown in a highlight colour, so that I know the device can't hit them exactly.
17. As an MPC Sample user, I want an Inexact Position that rounds to Tick 960 shown as the next Device Beat at `000` and still highlighted, so that I never see a Position the device can't have.
18. As an MPC Sample user, I want Grid Lines shown exactly where they fall when the Q value doesn't divide the Bar evenly (e.g. 7/8 with 1/4), leaving a short final gap, so that I see what will really happen.

### Timeline

19. As an MPC Sample user, I want a horizontal Timeline whose full width is one Bar, so that I can see how the Grid Lines are spread across it.
20. As an MPC Sample user, I want a line at every Beat, always labelled with its Beat number (1, 2, 3…), so that I can find my place in the Bar.
21. As an MPC Sample user, I want a marker at every Grid Line, so that I can see the whole grid.
22. As an MPC Sample user, I want faint, unlabelled Device Beat markers on the opposite edge from the Beat labels, so that I can see why a Beat lands at, say, `2:320`.
23. As an MPC Sample user, I want the zoomed-out Timeline to fit the screen width and label only as many Grid Lines as fit without overlapping, so that it stays readable when the grid is dense.
24. As an MPC Sample user, I want a button that switches between the zoomed-out and zoomed-in Timeline, so that I can choose between an overview and full detail.
25. As an MPC Sample user, I want the zoomed-in Timeline to scroll sideways with every Grid Line labelled with its Position, so that I can read each value against the drawing.
26. As an MPC Sample user, I want Inexact Positions on the Timeline highlighted the same way as in the table, so that both views agree.

### Grid Line table

27. As an MPC Sample user, I want a table under the Timeline listing every Grid Line, so that I can read exact values without zooming.
28. As an MPC Sample user, I want each row to show the Grid Line number, its Position, and the Beat number when it lands on a Beat, so that I can relate the grid to the Beats.
29. As an MPC Sample user, I want Inexact rows highlighted, so that I can spot them while scanning.
30. As an MPC Sample user, I want the table shown in both zoom views, so that the full list is always there.

### Standard Steps in 4/4

31. As an MPC Sample user, I want a "Standard Steps in 4/4" table at the bottom of STEP EDIT showing the Step for every Q value in 4/4 (960, 640, 480, 320, 240, 160, 120, 80, 60), so that I have a quick reference for the device's native grid.
32. As an MPC Sample user, I want that table to always show 4/4 values, whatever Time Signature I've chosen, so that it stays a fixed reference.
33. As an MPC Sample user, I want the column for the current Q value highlighted, so that I can find it quickly.

### Platform

34. As an MPC Sample user, I want to run the app in my browser on my own machine, so that I can use it next to the device without installing anything.
35. As the developer, I want the app built in Flutter, so that the same codebase can later become a phone app (ADR 0001).

## Implementation Decisions

- **Flutter app, web target only for now.** Package name `mpc_sample_helper`, app title "MPC Sample Helper". No phone build targets yet (ADR 0001).
- **Two modules, matching the two test seams:**
  - **`model`**: pure Dart with no Flutter imports. It turns a Time Signature and a Q value into everything STEP EDIT shows. It owns all the arithmetic.
  - **`app`**: the Flutter UI. The navigation shell, the STEP EDIT and Shortcuts Tools, the dropdowns, the Timeline painter, the tables and the zoom toggle. It renders the `model` output and does no musical arithmetic of its own.
- **`model` interface (shape, not exact names):**
  - A Time Signature value (beats 1–16, note value 4 or 8) and a Q value (the nine options, each knowing its label, note value and whether it's a triplet).
  - A single entry point that takes a Time Signature and a Q value and returns a layout containing:
    - the Grid Lines, each with its number (from 1), its fraction of the Bar (0 ≤ x < 1), its Position, and the Beat number when it lands exactly on a Beat;
    - the Beats, each with its number and fraction of the Bar;
    - the Device Beats (four) as fractions of the Bar.
  - A Position value holding the Device Beat (from 1), the Tick rounded to one decimal place, and an Inexact flag. It provides the display string.
  - The Standard Steps in 4/4: the Step in Ticks for each Q value in 4/4.
- **Emulation rule (ADR 0002):** the Bar is always 3840 Ticks (4 Device Beats × 960).
  - A Beat is 3840 ÷ beats Ticks.
  - The Step for Q = 1/n is 3840 × note value ÷ (beats × n). For triplets, multiply by 2/3.
  - Grid Lines sit at every multiple of the Step from 0 while below 3840.
- **Exact arithmetic:** compute positions as exact fractions (integer numerator and denominator), not floating point. Round only when building a Position for display. This keeps "lands exactly on a Beat", Inexact detection and the final-Grid-Line cutoff free of floating-point error.
- **Position display:**
  - Device Beat = whole-number part of (Tick ÷ 960) + 1, and Tick = the remainder.
  - Round the Tick to one decimal place, halves rounding up. If it rounds to 960.0, carry: Device Beat + 1 and Tick 0, still Inexact.
  - Format `beat:tick`. Pad the whole part of the Tick to three digits (`1:000`, `1:080`, `1:426.7`). Show a decimal only when Inexact.
  - A Position is Inexact when the exact Tick isn't a whole number, even if it rounds to one (e.g. 959.96 shows as `2:000`).
- **Q options:** all nine values are offered and look identical, including 1/4, 1/4T and 1/64, which the device doesn't support. They're there so users can explore those grids.
- **Settings state:** Time Signature and Q live in STEP EDIT's state with defaults 4/4 and 1/16. They aren't remembered between sessions.
- **Navigation:** a Material bottom navigation bar with two destinations, `STEP EDIT` and `Shortcuts`. STEP EDIT is selected at launch.
- **Casing rule:** only labels that appear on the device are uppercase. Right now that's `STEP EDIT` and `Q`. The user will name any others as they come up.
- **Timeline drawing:** a custom painter driven by the `model` layout's fractions.
  - Beat lines are labelled with the Beat number on one edge, and Device Beat markers sit faintly on the opposite edge.
  - Zoomed out, it fits the width and labels Grid Lines only where they won't overlap. Beat labels always show.
  - Zoomed in, it gives each Grid Line enough width for its Position label and scrolls sideways.
  - The toggle button switches between the two views. Zoomed out is the default.
- **Highlight:** one highlight colour, defined in the theme, marks Inexact Positions (Timeline labels and table rows) and the current Q column in Standard Steps in 4/4.

## Testing Decisions

- **Good tests check behaviour you can see from outside**: the values `model` returns, or what a user sees and can do in the running app. They don't depend on private helpers, widget tree structure or painter internals.
- **Seam `model` (most tests):** plain Dart unit tests on the single entry point and the Standard Steps in 4/4. Cases to cover:
  - 4/4 at every Q value: all Positions exact; the Grid Line count; 1/16 gives `1:000`, `1:240` … `4:720`.
  - 3/4 with 1/4 → `1:000`, `2:320`, `3:640`, each with its Beat number.
  - 3/4 with 1/8T → `1:426.7` and `1:853.3`, both Inexact.
  - 7/8 with 1/4 → four Grid Lines and a short final gap (the last Grid Line well before the end of the Bar).
  - 4/4 with 1/4T → six Grid Lines from 0 to `4:320`, all exact.
  - Rounding: a Tick that rounds to 960.0 carries to `next:000` and stays Inexact. Exact Ticks have no decimal point. Ticks are padded to three digits.
  - Beat numbers are set only on Grid Lines that land exactly on a Beat.
  - Standard Steps in 4/4 returns 960, 640, 480, 320, 240, 160, 120, 80, 60.
  - Edge Time Signatures: 1/4, 16/8, 5/8.
- **Seam `app` (a few tests):** widget tests that start the whole app and check:
  - It launches on STEP EDIT, and the bottom bar shows `STEP EDIT` and `Shortcuts`.
  - Shortcuts shows its intro sentence.
  - The defaults are 4/4 and Q 1/16, and the table starts `1:000`, `1:240`.
  - Changing the dropdowns to 3/4 and 1/4 updates the table to `1:000`, `2:320`, `3:640`.
  - Inexact rows are highlighted, and the current Q column in Standard Steps in 4/4 is highlighted.
  - The zoom button switches between the zoomed-out and zoomed-in Timeline.
- **Not automatically tested:** Timeline pixel geometry and label thinning. Check these by eye with the app running.
- **Prior art:** none. This is a new codebase. Use `flutter_test` for both seams. `model` tests need no widget binding.

## Out of Scope

- Phone app builds (iOS/Android) and public hosting.
- Remembering settings between sessions.
- Any Shortcuts content beyond the intro sentence.
- Marking or disabling Q values the device doesn't support.
- Export features (clipboard, CSV).
- Hover or click readouts, and typing a Tick to look up where it falls.
- Swing, multiple Bars, and MIDI input or output.

## Further Notes

- Glossary: `CONTEXT.md`. Decisions: `docs/adr/0001-flutter-for-web-and-future-mobile.md` and `docs/adr/0002-emulate-time-signatures-on-a-4-4-device-bar.md`.
- 960 Ticks per Device Beat is confirmed by the user. Akai's guide shows Step Edit Positions in this format, e.g. `001:02:952` (https://www.akaipro.com/guides/mpc-sample/step_edit.htm). The app leaves out the Bar number.
- The device's own name for Quantize is "Time Correct"; its grid value is labelled `Q`.
