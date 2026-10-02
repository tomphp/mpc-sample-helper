# 04: Fill in the Shortcuts from the edited candidates

**What to build:** The Shortcuts Tool lists every Shortcut the user kept in `.scratch/shortcuts/candidates.md`, grouped by Mode in the order the candidates file uses. Their wording is carried over into the bundled data file, and manual page numbers and flags are dropped.

**Blocked by:** 03 (Keycaps that look like the device, plus ranges and choices), and the user finishing their edits to `.scratch/shortcuts/candidates.md`

**Status:** ready-for-agent

- [ ] Every Shortcut kept in the candidates file is in the data file, with the same Mode, Gesture, condition and effect wording. Nothing deleted from the candidates file appears
- [ ] No page numbers or flags appear in the app
- [ ] The test that the real data file parses still passes
- [ ] Any candidate whose Gesture can't be written in the data format is raised with the user rather than dropped silently
- [ ] Checked by eye in Chrome: the full list at phone and desktop widths
- [ ] `flutter test` and `flutter analyze` pass
