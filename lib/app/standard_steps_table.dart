import 'package:flutter/material.dart';

import '../model/model.dart';
import 'theme.dart';

/// The Step for every Q value in 4/4, with the current Q highlighted.
class StandardStepsTable extends StatelessWidget {
  const StandardStepsTable({super.key, required this.current});

  final Quantize current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightStyle = HelperColors.of(context).highlightStyle;
    final steps = standardStepsIn44();

    TextStyle? styleFor(Quantize quantize) =>
        quantize == current ? highlightStyle : null;

    Widget cell(String text, [TextStyle? style]) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(text, style: style, textAlign: TextAlign.center),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Standard Steps in 4/4', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: TableBorder.all(color: theme.dividerColor),
            children: [
              TableRow(
                children: [
                  cell('Q', const TextStyle(fontWeight: FontWeight.bold)),
                  for (final quantize in Quantize.values)
                    cell(quantize.label, styleFor(quantize)),
                ],
              ),
              TableRow(
                children: [
                  cell('Step', const TextStyle(fontWeight: FontWeight.bold)),
                  for (final quantize in Quantize.values)
                    cell('${steps[quantize]}', styleFor(quantize)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
