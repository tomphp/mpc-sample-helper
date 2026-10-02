# 04: Time Signature emulation and Inexact Positions

**What to build:** The user picks a Time Signature with two dropdowns, beats 1–16 and a note value of 4 or 8 (default 4/4). The Grid Line table then shows the Bar emulated onto the 4/4 Device Bar: the Beats are spread evenly across 3840 Ticks, so 3/4 with Q at 1/4 gives `1:000`, `2:320`, `3:640`. Positions that aren't whole Ticks are Inexact. They're rounded to one decimal place (halves up), shown with the decimal, and their table rows are highlighted. Exact Positions never show a decimal. A Tick that rounds to 960.0 carries to the next Device Beat at `000` and stays Inexact. When Q doesn't divide the Bar evenly, Grid Lines are shown where they fall, leaving a short final gap. See ADR 0002.

**Blocked by:** 02 (Grid Line table in 4/4 with the Q dropdown)

**Status:** ready-for-agent

- [x] Time Signature dropdowns: beats 1–16 and note value 4 or 8, defaulting to 4/4
- [x] Changing either dropdown updates the table immediately
- [x] A Position is Inexact when its exact Tick isn't a whole number. It's shown rounded to one decimal place (e.g. `1:426.7`), and its table row is highlighted
- [x] A Tick that rounds to 960.0 shows as the next Device Beat at `000` and is still Inexact
- [x] Beat numbers appear only on Grid Lines that land exactly on a Beat of the chosen Time Signature
- [x] `model` unit tests:
  - 3/4 with 1/4 gives `1:000`, `2:320`, `3:640`, with Beats 1–3
  - 3/4 with 1/8T includes `1:426.7` and `1:853.3`, both Inexact
  - 7/8 with 1/4 gives four Grid Lines with a short final gap
  - a direct Position test covers the 960 carry
  - edge Time Signatures 1/4, 5/8 and 16/8
- [x] An `app` test checks that switching to 3/4 with Q at 1/4 shows `1:000`, `2:320`, `3:640`, and that an Inexact row is highlighted
- [x] `flutter test` and `flutter analyze` pass
