# 05: Add the Shortcuts found while mining the manual for Tips

**What to build:** These Shortcuts turned up while reviewing the MPC Sample User Guide v1.0 for Tips. They're single Gestures, so they belong in the Shortcuts Tool, not the Tips Tool. The user picks which ones to keep; the kept ones are added to `assets/shortcuts.yaml` under the right Mode.

**Blocked by:** None

**Status:** needs-triage

Candidates (manual page in brackets):

- Hold SEQ, press SAMPLE (or vice versa): Sample/Seq Mode, i.e. Sequence Mode's display while the pads still trigger samples (p.40)
- Hold SAMPLE, press a pad: select a sample without triggering it (p.24)
- In Sequence Mode, hold SHIFT, turn ENCODER: move the playhead by the current Q (p.39)
- Hold NOTE REPEAT: Note Repeat only while held; hold SHIFT while it's on to show triplet divisions on B1–B3 (p.19, p.34)
- Hold MUTE: mute only while held, from any Mode (p.31)
- Hold SHIFT, press MUTE: unmute all pads (p.31)
- In Sequence Mode, hold SHIFT, turn K1: set any length from 1 to 128 bars (p.39)

- [ ] The user has chosen which candidates to keep
- [ ] Every kept candidate is in the data file under the right Mode, with no page numbers
- [ ] The test that the real data file parses still passes
- [ ] `flutter test` and `flutter analyze` pass
