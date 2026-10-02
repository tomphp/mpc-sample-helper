# MPC Sample Helper

An app of small reference Tools for users of the Akai MPC Sample. Its first Tool, STEP EDIT, shows the Position of every Grid Line in one Bar, so users know what to enter in the device's Step Edit mode.

## Language

### Musical time

**Bar**:
One measure of the chosen Time Signature. It always occupies one full Device Bar, however many Beats it has.
_Avoid_: Measure, (graphical) bar

**Time Signature**:
The number of Beats in a Bar and the note value of each Beat (e.g. 3/4, 7/8). It is emulated: the device itself only supports 4/4.
_Avoid_: Meter

**Beat**:
One of the evenly spaced divisions of a Bar defined by the Time Signature (e.g. 3 Beats in 3/4).
_Avoid_: Count, pulse

**Quantize**:
The note value (e.g. 1/16, 1/8T), relative to the Time Signature, that divides a Bar into evenly spaced Grid Lines. Labelled `Q` on the device.
_Avoid_: Time division, grid size, Time Correct

**Grid Line**:
One position produced by the Quantize within the Bar.
_Avoid_: Division, grid marker

**Step**:
The distance in Ticks between two adjacent Grid Lines (e.g. 240 for 1/16 in 4/4).
_Avoid_: Grid size, interval, spacing

### Device

**Device Bar**:
The MPC Sample's bar: always 4/4, made of four Device Beats.
_Avoid_: Sequence bar

**Device Beat**:
One quarter note of the Device Bar, 960 Ticks long.
_Avoid_: Quarter, beat (when the Time Signature's Beat is meant)

**Tick**:
The smallest unit of time on the device; there are 960 per Device Beat.
_Avoid_: Pulse, clock, PPQN

**Position**:
Where something falls in the Device Bar, written as Device Beat and Tick (e.g. `2:320`), the way Step Edit displays it.
_Avoid_: Tick value, offset, time

**Inexact Position**:
A Position whose Tick is not a whole number; shown rounded to one decimal place and highlighted, because the device cannot hit it exactly.
_Avoid_: Fractional tick, approximate position

**Step Edit**:
The MPC Sample mode where a user edits an event's Position.
_Avoid_: Step editor, event editor, list editor

**Shortcut**:
A device action reached by a control combination that is not labelled on the front panel (e.g. SHIFT + Pad 14).
_Avoid_: Hidden function, key combo, hotkey

### App

**Tool**:
One feature of the app, presented as its own tab.
_Avoid_: Feature, page, screen

**Timeline**:
The horizontal strip whose full length represents one Bar, on which Beats and Grid Lines are drawn.
_Avoid_: Bar, ruler
