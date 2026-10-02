import 'package:flutter/material.dart';

import '../model/model.dart';
import 'grid_line_table.dart';
import 'standard_steps_table.dart';

class StepEditTool extends StatefulWidget {
  const StepEditTool({super.key});

  @override
  State<StepEditTool> createState() => _StepEditToolState();
}

class _StepEditToolState extends State<StepEditTool> {
  static const _timeSignature = TimeSignature(4, 4);
  Quantize _quantize = Quantize.sixteenth;

  @override
  Widget build(BuildContext context) {
    final layout = layoutBar(_timeSignature, _quantize);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownMenu<Quantize>(
            label: const Text('Q'),
            initialSelection: _quantize,
            requestFocusOnTap: false,
            dropdownMenuEntries: [
              for (final quantize in Quantize.values)
                DropdownMenuEntry(value: quantize, label: quantize.label),
            ],
            onSelected: (quantize) {
              if (quantize != null) setState(() => _quantize = quantize);
            },
          ),
          const SizedBox(height: 16),
          GridLineTable(
            key: const Key('grid-line-table'),
            gridLines: layout.gridLines,
          ),
          const SizedBox(height: 24),
          StandardStepsTable(
            key: const Key('standard-steps'),
            current: _quantize,
          ),
        ],
      ),
    );
  }
}
