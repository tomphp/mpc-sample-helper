import 'package:flutter/widgets.dart';

/// [widgets] with [separator] between each neighbouring pair.
List<Widget> separated(List<Widget> widgets, Widget separator) => [
  for (final (index, widget) in widgets.indexed) ...[
    if (index > 0) separator,
    widget,
  ],
];
