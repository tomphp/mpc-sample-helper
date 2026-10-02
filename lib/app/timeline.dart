import 'package:flutter/material.dart';

import '../model/model.dart';
import 'theme.dart';

/// One Bar drawn across the available width: numbered Beat lines along the
/// top, a marker at every Grid Line, faint Device Beat markers along the
/// bottom, and Grid Line Positions labelled wherever they fit.
class Timeline extends StatelessWidget {
  const Timeline({super.key, required this.layout});

  final BarLayout layout;

  static const height = 132.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _TimelinePainter(
          layout: layout,
          textStyle: Theme.of(context).textTheme.labelSmall!,
          colours: _TimelineColours(
            bar: scheme.surfaceContainerHighest,
            beat: scheme.onSurface,
            gridLine: scheme.outline,
            deviceBeat: scheme.outline.withValues(alpha: 0.45),
            label: scheme.onSurfaceVariant,
            highlight: HelperColors.of(context).highlight,
          ),
        ),
      ),
    );
  }
}

class _TimelineColours {
  const _TimelineColours({
    required this.bar,
    required this.beat,
    required this.gridLine,
    required this.deviceBeat,
    required this.label,
    required this.highlight,
  });

  final Color bar;
  final Color beat;
  final Color gridLine;
  final Color deviceBeat;
  final Color label;
  final Color highlight;
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.layout,
    required this.textStyle,
    required this.colours,
  });

  final BarLayout layout;
  final TextStyle textStyle;
  final _TimelineColours colours;

  /// Room either side so labels at the ends of the Bar aren't clipped.
  static const _inset = 24.0;
  static const _barTop = 22.0;
  static const _barBottom = 82.0;
  static const _deviceBeatMarker = 8.0;
  static const _labelTop = _barBottom + _deviceBeatMarker + 6;
  static const _labelGap = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width - 2 * _inset;
    double x(double barFraction) => _inset + barFraction * barWidth;

    // The Bar itself; its right edge is where the next Bar starts.
    canvas.drawRect(
      Rect.fromLTRB(_inset, _barTop, _inset + barWidth, _barBottom),
      Paint()..color = colours.bar,
    );
    final edge = Paint()
      ..color = colours.beat
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(_inset + barWidth, _barTop),
      Offset(_inset + barWidth, _barBottom),
      edge,
    );

    final gridLinePaint = Paint()
      ..color = colours.gridLine
      ..strokeWidth = 1;
    for (final line in layout.gridLines) {
      final lineX = x(line.barFraction);
      canvas.drawLine(
        Offset(lineX, _barBottom - (_barBottom - _barTop) * 0.4),
        Offset(lineX, _barBottom),
        gridLinePaint,
      );
    }

    final beatPaint = Paint()
      ..color = colours.beat
      ..strokeWidth = 2;
    for (final beat in layout.beats) {
      final beatX = x(beat.barFraction);
      canvas.drawLine(
        Offset(beatX, _barTop),
        Offset(beatX, _barBottom),
        beatPaint,
      );
      _drawText(
        canvas,
        '${beat.number}',
        textStyle.copyWith(color: colours.beat, fontWeight: FontWeight.bold),
        centreX: beatX,
        top: 2,
      );
    }

    final deviceBeatPaint = Paint()..color = colours.deviceBeat;
    for (final deviceBeat in layout.deviceBeats) {
      final markerX = x(deviceBeat);
      canvas.drawPath(
        Path()
          ..moveTo(markerX, _barBottom)
          ..lineTo(
            markerX - _deviceBeatMarker / 2,
            _barBottom + _deviceBeatMarker,
          )
          ..lineTo(
            markerX + _deviceBeatMarker / 2,
            _barBottom + _deviceBeatMarker,
          )
          ..close(),
        deviceBeatPaint,
      );
    }

    _paintGridLineLabels(canvas, barWidth, x);
  }

  /// Labels every n-th Grid Line, choosing the smallest n at which the
  /// labels don't overlap, from spacings that keep the labels in step with
  /// the Beats.
  void _paintGridLineLabels(
    Canvas canvas,
    double barWidth,
    double Function(double) x,
  ) {
    final lines = layout.gridLines;
    if (lines.isEmpty) return;

    final painters = [
      for (final line in lines)
        _layoutText(
          '${line.position}',
          textStyle.copyWith(
            color: line.position.isInexact ? colours.highlight : colours.label,
            fontWeight: line.position.isInexact ? FontWeight.bold : null,
          ),
        ),
    ];
    final widest = painters.fold(0.0, (w, p) => w > p.width ? w : p.width);
    final spacing = lines.length > 1
        ? (lines[1].barFraction - lines[0].barFraction) * barWidth
        : barWidth;
    final every = _beatAlignedStrides(lines).firstWhere(
      (n) => n * spacing >= widest + _labelGap,
      orElse: () => lines.length,
    );

    for (var i = 0; i < lines.length; i += every) {
      final painter = painters[i];
      painter.paint(
        canvas,
        Offset(x(lines[i].barFraction) - painter.width / 2, _labelTop),
      );
    }
  }

  /// Label spacings, smallest first, that never skip a Grid Line on a Beat:
  /// the divisors of the gap between on-Beat Grid Lines, then its multiples.
  static Iterable<int> _beatAlignedStrides(List<GridLine> lines) sync* {
    final onBeat = [
      for (var i = 0; i < lines.length; i++)
        if (lines[i].beat != null) i,
    ];
    final period = onBeat.length > 1 ? onBeat[1] - onBeat[0] : lines.length;
    for (var n = 1; n < period; n++) {
      if (period % n == 0) yield n;
    }
    for (var n = period; n < lines.length; n += period) {
      yield n;
    }
  }

  TextPainter _layoutText(String text, TextStyle style) => TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();

  void _drawText(
    Canvas canvas,
    String text,
    TextStyle style, {
    required double centreX,
    required double top,
  }) {
    final painter = _layoutText(text, style);
    painter.paint(canvas, Offset(centreX - painter.width / 2, top));
  }

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.layout != layout || old.textStyle != textStyle;
}
