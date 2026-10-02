# 02: Tracer: the Tips & Tricks Tool with one Tip

**What to build:** A Tips & Tricks tab, after Shortcuts in the bottom navigation bar. It shows an intro sentence and the *Resample a live performance* Tip, read from a new bundled Tip data file. The Tip appears as a card in the Shortcut entry's style, with a title, a one-line outcome and numbered steps. In step and note text, a `[Control]` marker (e.g. `[SHIFT]`, `[SAMPLE RECORD]`, `[pad 14]`) renders as an inline keycap that wraps with the words. Plain text such as RECALL or INPUT CONFIG stays as text. An optional note appears after the steps. A malformed data file shows its error in the Tool. See the spec, `.scratch/tips/spec.md`, for the data format, the parser contract and the Tip's wording (user story 16).

**Blocked by:** 01 (Share Control references and expose a standalone Control keycap)

**Status:** ready-for-agent

- [ ] The app still launches on STEP EDIT, with STEP EDIT, Shortcuts and Tips & Tricks tabs in that order; the existing launch test is updated
- [ ] The Tip data file is bundled and starts with a comment describing its format: a top-level `tips` list, where each Tip has `title`, `outcome`, `steps` (non-empty list of text) and an optional `note`
- [ ] `parseTips` returns Tips in file order, with steps and the note split into plain-text and Control segments; markers accept every Control reference the Shortcut data file does
- [ ] Malformed data fails with a `TipDataException` naming the Tip and field: unknown Control in a marker, an unclosed or empty marker, a missing title or outcome, missing or empty steps, a non-text step or note, an unknown key, or no top-level `tips` list
- [ ] The Tool shows the intro sentence, then each Tip's title, outcome, numbered steps and, when present, the note
- [ ] Markers render as `ControlKeycap`s inline with the text, with no action word
- [ ] A parse error is shown in the Tool in the highlight style
- [ ] The bundled data file contains the *Resample a live performance* Tip, worded as agreed ("the last 25 seconds"), and a test checks the file parses
- [ ] Widget tests go through the whole app with a stub asset bundle, following the Shortcuts Tool test
- [ ] Checked by eye in Chrome at phone and desktop widths
- [ ] `flutter test` and `flutter analyze` pass
