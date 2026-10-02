# 01: Share Control references and expose a standalone Control keycap

**What to build:** A prefactor with no visible change. The Shortcut parser's Control-reference parsing (front-panel labels, symbol names such as STOP, "pad 14", "pads 1–8", "any pad", and choices such as "K1 / K2 / K3") becomes reusable by a second parser, so the Tip parser can share it instead of duplicating it. The Control drawing that `Keycap` uses privately becomes a public `ControlKeycap` that draws a Control reference with no action word. `Keycap` keeps its current look and is built from it.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] Control-reference parsing is callable from outside the Shortcut parser, and the Shortcut parser uses it
- [ ] Malformed Control references still give the same error messages in the Shortcut data file
- [ ] A public `ControlKeycap` draws any Control reference without an action word
- [ ] `Keycap` is built from `ControlKeycap` and its appearance is unchanged
- [ ] All existing tests pass unchanged
- [ ] Checked by eye in Chrome: the Shortcuts Tool looks the same as before
- [ ] `flutter test` and `flutter analyze` pass
