# Spec: MPC Sample Helper — Tips & Tricks Tool

Status: ready-for-agent

## Problem Statement

The MPC Sample can do things that no single feature offers on its own: capturing a whole live performance (pads, sequences, PAD FX, KNOB FX, FLEX BEAT, knob and fader moves) as a new sample, or moving an event further than the fader allows in Step Edit. These workflows come from combining features in ways the 67-page manual describes only in passing, or not at all. Users find them by accident or from other users. The Shortcuts Tool doesn't help, because a Shortcut is a single Gesture with a single effect, and these are multi-step Tips.

## Solution

A third Tool, **Tips & Tricks**, lists Tips in a deliberate order with no grouping. Each Tip has a title, a one-line outcome, numbered steps and an optional note. Control names in the steps are drawn as keycaps that look like the Controls on the device, matching the Shortcuts Tool, so a user can find the right button by sight. The Tips come from a data file bundled with the app that the user can edit directly, the same way Shortcuts do.

The Tool launches with four Tips: resampling a live performance, moving events further with the fader, layering two pads with Pad Link, and shifting one pad's timing.

## User Stories

### Finding the Tool

1. As an MPC Sample user, I want a Tips & Tricks tab in the bottom navigation bar, so that I can find workflows I wouldn't discover on my own.
2. As an MPC Sample user, I want Tips & Tricks to sit after Shortcuts, so that the existing Tools stay where I'm used to finding them.
3. As an MPC Sample user, I want the app to still launch on STEP EDIT, so that adding a Tool doesn't change my starting point.
4. As an MPC Sample user, I want switching tabs to keep each Tool's state, so that going to Tips & Tricks and back doesn't reset STEP EDIT.
5. As an MPC Sample user, I want a short intro sentence at the top of the Tool, so that I know these are workflows that combine features, not single Shortcuts.

### Reading a Tip

6. As an MPC Sample user, I want each Tip to have a title, so that I can scan the list for what I want to do.
7. As an MPC Sample user, I want a one-line outcome under each title, so that I know what the Tip achieves before reading the steps.
8. As an MPC Sample user, I want the steps numbered, so that I can follow them in order while my hands are on the device.
9. As an MPC Sample user, I want Control names in a step drawn as keycaps that look like the device's Controls, so that I can match them to the front panel by sight.
10. As an MPC Sample user, I want inline keycaps to show only the Control, with no action word above it, so that they read as part of the sentence.
11. As an MPC Sample user, I want pads written as numbered pads, e.g. pad 14, to be drawn as pads, so that "SHIFT + pad 14" looks like the gesture I'll make.
12. As an MPC Sample user, I want an optional note after the steps, so that caveats (e.g. "only within the same Pad Bank") are clearly separate from the instructions.
13. As an MPC Sample user, I want each Tip shown as its own card in the device's style, so that Tips are visually distinct, the way Shortcuts are.
14. As an MPC Sample user, I want Tips shown in the order the data file lists them, so that related Tips stay next to each other.
15. As an MPC Sample user, I want the Tool to read well at phone and desktop widths, with keycaps wrapping along with the text, so that I can use it next to my device on any screen.

### The launch Tips

16. As an MPC Sample user, I want a Tip on resampling a live performance: set Source to Resample in INPUT CONFIG (SHIFT + SAMPLE), play live (hit pads, play sequences, use PAD FX, KNOB FX or FLEX BEAT, move the knobs or the FADER), then press SHIFT + SAMPLE RECORD to RECALL the last 25 seconds onto the next available pad. That way I can turn a performance into a sample without having armed recording.
17. As an MPC Sample user, I want a Tip on moving events further with the fader: in Step Edit, select the event with ENCODER and nudge it with FADER. The FADER only moves an event within the current Q's Step, so to go further I switch K2 to a coarser Q and nudge again. That way I can place events anywhere, not just near their Grid Line.
18. As an MPC Sample user, I want that Tip's note to explain that at 1/4 there's no coarser Q: I switch to 1/4T, whose Grid Lines don't line up with the beats, so the event's Step overlaps the next beat, and I alternate between straight and triplet values to leapfrog. That way I'm not stuck at the coarsest Q.
19. As an MPC Sample user, I want a Tip on layering two pads with Pad Link: in Sample Mode, select the pad, press B2 until you reach the Play page, then hold SHIFT and turn K2 to choose the pad that fires with it. That way one hit plays a layered sound.
20. As an MPC Sample user, I want the Pad Link Tip to note that linking only works within the same Pad Bank, so that I don't wonder why it fails across banks.
21. As an MPC Sample user, I want a Tip on shifting just one pad's timing: open Time Correct (SHIFT + pad 14), select the pad(s), turn K2 (Shift) to move their events earlier or later, then press B3 (Do It!) to apply. That way I can, for example, push only the snare slightly late.
22. As an MPC Sample user, I want the Tip wording to use the device's names (Mode names, Control labels, Shift Labels such as RECALL and INPUT CONFIG), so that what I read matches what I see on the device.

### Editing the Tips

23. As the app's author, I want the Tips in a bundled data file, so that I can add or reword a Tip without touching code.
24. As the app's author, I want the data file to start with a comment describing its format, so that I can edit it without looking anything up.
25. As the app's author, I want to mark a Control in a step with a short marker, e.g. `[K2]`, so that writing a step stays close to writing a sentence.
26. As the app's author, I want a marker to accept every Control reference the Shortcut data file does (front-panel labels, symbol names such as STOP, "pad 14", ranges such as "pads 1–8", "any pad", and choices such as "K1 / K2 / K3"), so that I only have to learn one way of naming Controls.
27. As the app's author, I want text outside markers, including Shift Labels like RECALL or menu names like INPUT CONFIG, to stay plain text, so that only real Controls become keycaps.
28. As the app's author, I want a malformed Tip (unknown Control in a marker, missing title, missing outcome, no steps, a note that isn't text, an unknown key) to fail with a message naming the Tip, so that I can fix the file quickly.
29. As the app's author, I want an unclosed or empty marker to fail with a message naming the Tip, so that a typo doesn't silently show brackets in the app.
30. As the app's author, I want a broken data file to show its error in the Tool rather than a blank screen, so that I notice the mistake when I check the app.
31. As the app's author, I want a test to fail if the bundled data file doesn't parse, so that a bad edit never ships.

## Implementation Decisions

- **Glossary:** **Tip** is now defined in `CONTEXT.md`: a workflow that combines features of the device over several steps to achieve something more advanced than any one of them does alone. A single Gesture with a single effect is a Shortcut, not a Tip. "Tips & Tricks" is the Tool's name; the things in it are Tips.
- **New Tool:** Tips & Tricks becomes the third entry in the app shell's list of Tools, after Shortcuts. It uses a fitting Material icon such as a lightbulb. Like the other Tools it lives in the shell's IndexedStack, so its state survives tab switches.
- **Data file:** a new bundled YAML asset, declared alongside the Shortcut data file, with a comment header describing its format. It has a top-level `tips` list, and each Tip has:
  - `title`: text, required
  - `outcome`: text, required
  - `steps`: a non-empty list of text, required
  - `note`: text, optional

  Unknown keys are rejected, as they are in the Shortcut data file.
- **Markers:** in step and note text, a Control reference in square brackets (e.g. `[K2]`, `[pad 14]`, `[SAMPLE RECORD]`) marks a Control. Everything outside markers is plain text. A marker is resolved with the same Control-reference parsing the Shortcut data file uses, so that parsing moves somewhere both parsers can share. It must not be duplicated. Outcomes and titles are plain text with no markers.
- **Model:** a pure-Dart module, exported from the model library next to the Shortcut data. It provides:
  - A `Tip` with a title, an outcome, a list of steps and an optional note.
  - Steps and the note are rich text: an ordered list of segments, each either plain text or a Control reference.
  - `parseTips(String yaml)` returns the Tips in file order.
  - A `TipDataException`, whose message names the Tip by number and title (when it has one) and the field at fault, in the style of `ShortcutDataException`.
- **Rendering:** the Tool loads the asset through `DefaultAssetBundle`, exactly as the Shortcuts Tool does, and shows any parse error in the highlight style. Each Tip is a card in the Shortcut entry's style:
  - the title in the heading style
  - the outcome in muted text
  - numbered steps
  - the note set apart after the steps (e.g. muted or prefixed "Note:")

  Rich text is built with inline widget spans, so keycaps wrap with the words.
- **Inline keycaps:** today the only public widget for a Control is `Keycap`, which draws a Gesture step with its action word. The private Control drawing becomes public, for example as a `ControlKeycap` that takes a Control reference. It is sized to sit inline with body text and has no action word. `Keycap` keeps its current appearance by composing it.
- **Launch content:** the four Tips in this order:
  1. Resample a live performance
  2. Move events further with the fader
  3. Layer two pads with Pad Link
  4. Shift just one pad's timing

  Their steps and notes are as in user stories 16–21. Wording decisions:
  - RECALL captures "the last 25 seconds", following the manual's body text (pp. 23, 38) and the author's device rather than the spec table's 30.
  - The fader Tip says only that the FADER nudges within the current Q's Step. It doesn't give the size of that range.
  - INPUT CONFIG, RECALL, Time Correct and Do It! are Shift Labels or screen names, not Controls, so they stay plain text next to the Control keycaps.
- **Intro sentence:** one line at the top of the Tool, in the style of the Shortcuts intro, e.g. "Workflows that combine features to do something more advanced."

## Testing Decisions

- Tests check external behaviour only: what `parseTips` returns or throws for a given YAML string, and what a user sees in the running app. They don't test private widgets or how the parser works internally.
- **Model tests** for `parseTips`, following the existing Shortcut parser tests:
  - reads a Tip with title, outcome, steps and note
  - keeps Tips in file order
  - a note is optional
  - splits a step into plain text and Control segments, including at the start and end of a step and with adjacent markers
  - accepts pads, pad ranges, "any pad", symbol names and choices in markers
  - malformed data names the Tip: an unknown Control in a marker, an unclosed or empty marker, a missing title, a missing outcome, missing or empty steps, a non-text step or note, an unknown key, a missing top-level `tips` list
- **Data file test:** the bundled Tip data file parses and contains at least one Tip, following the Shortcut data file test.
- **Widget tests through the whole app**, pumping it with a stub asset bundle the way the Shortcuts Tool test does:
  - the app launches on STEP EDIT with STEP EDIT, Shortcuts and Tips & Tricks tabs (the existing launch test is updated)
  - the Tips & Tricks tab shows its intro sentence
  - Tips appear in file order with title, outcome and numbered steps
  - a marker renders as a keycap showing the Control's label (e.g. a symbol for STOP) with no action word, and the surrounding text remains
  - a note appears after the steps when present and is absent otherwise
  - a malformed data file shows its error in the Tool
- Shortcuts Tool tests must still pass unchanged, since `Keycap`'s appearance is unchanged.
- Checked by eye in Chrome at phone and desktop widths: keycaps wrap inline with the text, and the cards match the Shortcuts Tool's look.
- `flutter test` and `flutter analyze` pass.

## Out of Scope

- Grouping Tips by theme or Mode. With four Tips, a flat ordered list is enough; revisit when the list grows.
- Linking to or repeating Tips from the STEP EDIT Tool or the Shortcuts Tool.
- The other manual candidates not chosen: capturing a jam with SEQ RECORD / RECALL, bouncing a sequence at Rec Length = Seq, printing Knob FX with Rec Input Effects, chopping while recording, extracting or splitting slices, stacking effect engines, Song Mode export, and undoing a whole recording pass.
- New Shortcuts found while mining the manual. These are tracked separately in the Shortcuts issues (05).
- Searching, filtering or bookmarking Tips.
- Images, diagrams or video in Tips.
- Authoring Tips in HTML or Markdown.

## Further Notes

- Source: Akai MPC Sample User Guide v1.0. Step Edit FADER and ENCODER behaviour is on p.43; RECALL on pp.23 and 38 (the spec table on p.65 says 30 seconds); Resample on pp.37 and 57; Pad Link on p.28; Time Correct Shift on p.59. The fader-and-Q technique and the triplet leapfrog come from the author's own use of the device; the manual doesn't describe them.
- No ADR: storing Tips as bundled YAML follows the Shortcuts Tool and is easy to reverse.
- A suggested slicing is a tracer first (the Tool with one Tip, the model, markers and inline keycaps end to end), then filling in the remaining three Tips.
