import 'package:yaml/yaml.dart';

import 'control.dart';

/// What a Gesture step does to its Control.
enum GestureAction {
  press('press'),
  pressTwice('press twice'),
  hold('hold'),
  release('release'),
  turn('turn'),
  pressAndTurn('press and turn'),
  move('move'),
  tap('tap');

  const GestureAction(this.word);

  /// How the Shortcut data file and the app write this action.
  final String word;

  static GestureAction? byWord(String word) {
    for (final action in values) {
      if (action.word == word) return action;
    }
    return null;
  }
}

/// One action on one Control.
class GestureStep {
  const GestureStep(this.action, this.control);

  final GestureAction action;
  final ControlRef control;
}

/// A useful action reached by a Gesture whose effect isn't printed on the
/// front panel.
class Shortcut {
  const Shortcut({required this.gesture, required this.effect, this.condition});

  /// The ordered steps that trigger it.
  final List<GestureStep> gesture;

  /// When it applies, e.g. "while stopped".
  final String? condition;

  final String effect;
}

/// The Shortcuts that apply in one Mode.
class ShortcutMode {
  const ShortcutMode(this.name, this.shortcuts);

  final String name;
  final List<Shortcut> shortcuts;
}

/// The Shortcut data file is malformed.
class ShortcutDataException implements Exception {
  const ShortcutDataException(this.message);

  final String message;

  @override
  String toString() => 'ShortcutDataException: $message';
}

/// Reads the Shortcut data file: Modes in order, each with its Shortcuts.
List<ShortcutMode> parseShortcuts(String yaml) {
  final document = loadYaml(yaml);
  final modes = document is YamlMap ? document['modes'] : null;
  if (modes is! YamlList) {
    throw const ShortcutDataException('expected a top-level "modes" list');
  }
  return [
    for (final (index, mode) in modes.indexed) _parseMode(index + 1, mode),
  ];
}

ShortcutMode _parseMode(int number, Object? mode) {
  final name = mode is YamlMap ? mode['mode'] : null;
  if (name is! String || name.trim().isEmpty) {
    throw ShortcutDataException('Mode $number has no name');
  }
  final shortcuts = mode is YamlMap ? mode['shortcuts'] : null;
  if (shortcuts is! YamlList) {
    throw ShortcutDataException('Mode "$name" has no "shortcuts" list');
  }
  return ShortcutMode(name, [
    for (final (index, shortcut) in shortcuts.indexed)
      _parseShortcut('Mode "$name", Shortcut ${index + 1}', shortcut),
  ]);
}

Shortcut _parseShortcut(String where, Object? shortcut) {
  if (shortcut is! YamlMap) {
    throw ShortcutDataException('$where: expected gesture and effect');
  }
  final effect = shortcut['effect'];
  if (effect is! String || effect.trim().isEmpty) {
    throw ShortcutDataException('$where: missing effect');
  }
  final steps = shortcut['gesture'];
  if (steps is! YamlList || steps.isEmpty) {
    throw ShortcutDataException('$where: empty gesture');
  }
  final condition = shortcut['when'];
  return Shortcut(
    gesture: [for (final step in steps) _parseStep(where, step)],
    condition: condition is String ? condition : null,
    effect: effect,
  );
}

GestureStep _parseStep(String where, Object? step) {
  if (step is! YamlMap || step.length != 1) {
    throw ShortcutDataException(
      '$where: each gesture step must be "action: Control"',
    );
  }
  final MapEntry(:key, :value) = step.entries.single;
  final action = GestureAction.byWord('$key');
  if (action == null) {
    throw ShortcutDataException('$where: unknown action "$key"');
  }
  return GestureStep(action, _parseControl(where, '$value'));
}

final _padPattern = RegExp(r'^pad (\d+)$');
final _padRangePattern = RegExp(r'^pads (\d+)[–-](\d+)$');

bool _isPadNumber(int number) => number >= 1 && number <= 16;

ControlRef _parseControl(String where, String reference) {
  if (reference.contains(' / ')) {
    return ControlChoice([
      for (final option in reference.split(' / '))
        _parseControl(where, option.trim()),
    ]);
  }

  if (reference == 'any pad') return const AnyPad();

  final pad = _padPattern.firstMatch(reference);
  if (pad != null) {
    final number = int.parse(pad.group(1)!);
    if (_isPadNumber(number)) return Pad(number);
  }

  final range = _padRangePattern.firstMatch(reference);
  if (range != null) {
    final first = int.parse(range.group(1)!);
    final last = int.parse(range.group(2)!);
    if (_isPadNumber(first) && _isPadNumber(last) && first < last) {
      return PadRange(first, last);
    }
  }

  final control = Control.byReference(reference);
  if (control == null) {
    throw ShortcutDataException('$where: unknown Control "$reference"');
  }
  return SingleControl(control);
}
