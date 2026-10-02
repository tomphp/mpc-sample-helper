# Emulate Time Signatures on a fixed 4/4 Device Bar

Status: superseded by ADR 0003 — the device does support other Time Signatures.

The MPC Sample only supports 4/4, so every Time Signature is emulated by spreading its Beats evenly across one 4/4 Device Bar of 3840 Ticks (4 Device Beats × 960). A 3/4 Bar is therefore 3840 Ticks with Beats at `1:000`, `2:320` and `3:640`, not a 2880-Tick bar. This mirrors how users fake other meters on the device; the cost is that many Grid Lines become Inexact Positions, which are rounded to one decimal place and highlighted rather than hidden.
