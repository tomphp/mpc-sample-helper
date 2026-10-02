# MPC Sample Helper

An app of small reference Tools for users of the Akai MPC Sample. Its first Tool, STEP EDIT, shows the Position of every Grid Line in one Bar, so users know what to enter in the device's Step Edit mode.

## Language

### Musical time

**Bar**:
One measure of the chosen Time Signature: its number of Beats times the Ticks in one Beat (e.g. 2880 Ticks in 3/4, 3360 in 7/8).
_Avoid_: Measure, (graphical) bar, Device Bar

**Time Signature**:
The number of Beats in a Bar and the note value of each Beat (e.g. 3/4, 7/8). Set per Project on the device, so every sequence shares it. The device offers 2/4, 3/4, 4/4, 5/4, 6/4, 7/4, 6/8, 7/8, 9/8, 10/8, 11/8 and 12/8.
_Avoid_: Meter

**Beat**:
One of the evenly spaced divisions of a Bar defined by the Time Signature (e.g. 3 Beats in 3/4): a quarter note (960 Ticks) in x/4, an eighth note (480 Ticks) in x/8. In compound Time Signatures such as 6/8 every Beat counts the same; there's no grouping.
_Avoid_: Count, pulse, Device Beat

**Quantize**:
The note value (e.g. 1/16, 1/8T) that divides a Bar into evenly spaced Grid Lines. It's independent of the Time Signature: 1/16 is always 240 Ticks. Labelled `Q` on the device.
_Avoid_: Time division, grid size, Time Correct

**Grid Line**:
One position produced by the Quantize within the Bar.
_Avoid_: Division, grid marker

**Step**:
The distance in Ticks between two adjacent Grid Lines (e.g. 240 for 1/16).
_Avoid_: Grid size, interval, spacing

### Device

**Project**:
The device's top-level unit of work; its sequences all share one Time Signature.
_Avoid_: Song, session

**Tick**:
The smallest unit of time on the device; there are 960 per quarter note.
_Avoid_: Pulse, clock, PPQN

**Position**:
Where something falls in the Bar, written as Beat and Tick (e.g. `2:320`; in 6/8, `6:240`), the way Step Edit displays it. Every Position is a whole number of Ticks.
_Avoid_: Tick value, offset, time

**Step Edit**:
The MPC Sample mode where a user edits an event's Position.
_Avoid_: Step editor, event editor, list editor

**Mode**:
The device state that decides what Controls do (e.g. Sample Mode, Sequence Mode, Step Edit, Chop Mode). Shortcuts are grouped by Mode.
_Avoid_: Screen, page, view

**Control**:
A physical input on the MPC Sample: a button, pad, knob (K1–K3), the ENCODER, the fader, or a function button (B1–B3).
_Avoid_: Key, input, hardware button

**Shift Label**:
The secondary function printed beneath a Control, reached by holding SHIFT (e.g. STEP EDIT under SEQ).
_Avoid_: Secondary label, alt function

**Shortcut**:
A useful action reached by a gesture on one or more Controls whose effect is printed on the front panel neither as a Control's label nor as its Shift Label (e.g. pressing STOP twice to stop all audio).
_Avoid_: Hidden function, key combo, hotkey

**Gesture**:
The ordered actions on Controls that trigger a Shortcut (e.g. hold ERASE, press a pad), optionally under a condition such as "while stopped".
_Avoid_: Combo, chord, key sequence

**Tip**:
A workflow that combines features of the device over several steps to achieve something more advanced than any one of them does alone (e.g. resampling a live performance and capturing it with RECALL). A single Gesture with a single effect is a Shortcut, not a Tip.
_Avoid_: Trick, hack, recipe

### App

**Tool**:
One feature of the app, presented as its own tab.
_Avoid_: Feature, page, screen

**Timeline**:
The horizontal strip whose full length represents one Bar, on which Beats and Grid Lines are drawn.
_Avoid_: Bar, ruler
