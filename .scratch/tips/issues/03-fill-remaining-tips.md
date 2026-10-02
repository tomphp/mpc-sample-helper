# 03: Fill in the remaining three Tips

**What to build:** The Tips & Tricks Tool lists all four launch Tips in this order: *Resample a live performance*, *Move events further with the fader*, *Layer two pads with Pad Link*, *Shift just one pad's timing*. The new Tips are worded as agreed in the spec, `.scratch/tips/spec.md` (user stories 17–21): the fader Tip says only that the FADER nudges within the current Q's Step, and its note explains the 1/4T leapfrog. The Pad Link note says it only works within the same Pad Bank. This is a data-only change.

**Blocked by:** 02 (Tracer: the Tips & Tricks Tool with one Tip)

**Status:** ready-for-agent

- [ ] All four Tips are in the data file in the order above, with titles, outcomes, steps and notes as agreed
- [ ] Controls in the steps are marked so they render as keycaps; Shift Labels and screen names (RECALL, INPUT CONFIG, Time Correct, Do It!) stay plain text
- [ ] Any wording that can't be expressed in the data format is raised with the user rather than changed silently
- [ ] The test that the real data file parses still passes
- [ ] Checked by eye in Chrome at phone and desktop widths
- [ ] `flutter test` and `flutter analyze` pass
