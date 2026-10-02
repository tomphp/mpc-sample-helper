import 'package:yaml/yaml.dart';

import 'control.dart';
import 'data_file.dart';

/// Part of a line of Tip text: plain words or a Control marker.
sealed class TipSegment {
  const TipSegment();
}

class PlainText extends TipSegment {
  const PlainText(this.text);

  final String text;

  @override
  bool operator ==(Object other) => other is PlainText && other.text == text;

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => text;
}

/// A Control written in square brackets in Tip text, e.g. "[K2]"; drawn
/// as a keycap.
class ControlMarker extends TipSegment {
  const ControlMarker(this.control);

  final ControlRef control;

  @override
  bool operator ==(Object other) =>
      other is ControlMarker && other.control == control;

  @override
  int get hashCode => control.hashCode;

  @override
  String toString() => '[$control]';
}

/// A step or note: text with Controls mentioned inline.
class TipLine {
  const TipLine(this.segments);

  final List<TipSegment> segments;

  @override
  bool operator ==(Object other) =>
      other is TipLine &&
      other.segments.length == segments.length &&
      other.segments.indexed.every((entry) => segments[entry.$1] == entry.$2);

  @override
  int get hashCode => Object.hashAll(segments);

  @override
  String toString() => segments.join();
}

/// A workflow that combines features of the device over several steps.
class Tip {
  const Tip({
    required this.title,
    required this.outcome,
    required this.steps,
    this.note,
  });

  final String title;

  /// What following the Tip achieves.
  final String outcome;

  final List<TipLine> steps;

  /// A caveat shown after the steps.
  final TipLine? note;
}

/// The Tip data file is malformed.
class TipDataException implements Exception {
  const TipDataException(this.message);

  final String message;

  @override
  String toString() => 'TipDataException: $message';
}

/// Reads the Tip data file: Tips in order.
List<Tip> parseTips(String yaml) {
  final document = loadYaml(yaml);
  final tips = document is YamlMap ? document['tips'] : null;
  if (tips is! YamlList) {
    throw const TipDataException('expected a top-level "tips" list');
  }
  return [for (final (index, tip) in tips.indexed) _parseTip(index + 1, tip)];
}

const _tipKeys = {'title', 'outcome', 'steps', 'note'};

Tip _parseTip(int number, Object? tip) {
  if (tip is! YamlMap) {
    throw TipDataException('Tip $number: expected title, outcome and steps');
  }
  final title = tip['title'];
  if (title is! String || title.trim().isEmpty) {
    throw TipDataException('Tip $number has no title');
  }
  final where = 'Tip $number "$title"';
  checkKeys(where, tip, _tipKeys, TipDataException.new);
  final outcome = tip['outcome'];
  if (outcome is! String || outcome.trim().isEmpty) {
    throw TipDataException('$where: missing outcome');
  }
  final steps = tip['steps'];
  if (steps is! YamlList || steps.isEmpty) {
    throw TipDataException('$where: no steps');
  }
  final note = tip['note'];
  return Tip(
    title: title,
    outcome: outcome,
    steps: [
      for (final (index, step) in steps.indexed)
        _parseLine('$where, step ${index + 1}', step),
    ],
    note: note == null ? null : _parseLine('$where, note', note),
  );
}

final _markerPattern = RegExp(r'\[([^\[\]]*)\]');

/// Splits text into plain words and Control markers, e.g. "[K2]".
TipLine _parseLine(String where, Object? text) {
  if (text is! String) throw TipDataException('$where: must be text');
  final segments = <TipSegment>[];
  void addPlain(String plain) {
    if (plain.isEmpty) return;
    if (plain.contains('[') || plain.contains(']')) {
      throw TipDataException('$where: unmatched bracket');
    }
    segments.add(PlainText(plain));
  }

  var plainStart = 0;
  for (final marker in _markerPattern.allMatches(text)) {
    addPlain(text.substring(plainStart, marker.start));
    segments.add(ControlMarker(_parseMarker(where, marker.group(1)!)));
    plainStart = marker.end;
  }
  addPlain(text.substring(plainStart));
  return TipLine(segments);
}

ControlRef _parseMarker(String where, String reference) {
  if (reference.trim().isEmpty) {
    throw TipDataException('$where: empty Control marker');
  }
  return parseControlIn(where, reference.trim(), TipDataException.new);
}
