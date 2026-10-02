import 'package:flutter/material.dart';

import '../model/model.dart';
import 'keycap.dart';
import 'theme.dart';

/// Tips in order, read from the bundled Tip data file.
class TipsTool extends StatefulWidget {
  const TipsTool({super.key});

  @override
  State<TipsTool> createState() => _TipsToolState();
}

class _TipsToolState extends State<TipsTool> {
  Future<List<Tip>>? _tips;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tips ??= DefaultAssetBundle.of(context)
        .loadString('assets/tips.yaml')
        .then(parseTips);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tips,
      builder: (context, snapshot) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Workflows that combine features to do something more advanced.',
          ),
          if (snapshot.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                '${snapshot.error}',
                style: HelperColors.of(context).highlightStyle,
              ),
            ),
          for (final tip in snapshot.data ?? const <Tip>[]) _TipEntry(tip: tip),
        ],
      ),
    );
  }
}

class _TipEntry extends StatelessWidget {
  const _TipEntry({required this.tip});

  final Tip tip;

  @override
  Widget build(BuildContext context) {
    final muted = TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tip.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(tip.outcome, style: muted),
          for (final (index, step) in tip.steps.indexed)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(width: 28, child: Text('${index + 1}.')),
                  Expanded(child: _LineText(step)),
                ],
              ),
            ),
          if (tip.note case final note?)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _LineText(note, style: muted),
            ),
        ],
      ),
    );
  }
}

/// A step or note, with its Controls drawn as keycaps among the words.
class _LineText extends StatelessWidget {
  const _LineText(this.line, {this.style});

  final TipLine line;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          for (final segment in line.segments)
            switch (segment) {
              PlainText(:final text) => TextSpan(text: text),
              ControlMention(:final control) => WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: ControlKeycap(control),
                ),
              ),
            },
        ],
      ),
      style: style,
    );
  }
}
