import 'package:flutter/material.dart';

import '../model/model.dart';
import 'grid_line_table.dart';
import 'standard_steps_table.dart';
import 'timeline.dart';

class StepEditTool extends StatefulWidget {
  const StepEditTool({super.key});

  @override
  State<StepEditTool> createState() => _StepEditToolState();
}

class _StepEditToolState extends State<StepEditTool> {
  int _beats = 4;
  int _noteValue = 4;
  Quantize _quantize = Quantize.sixteenth;
  bool _zoomedIn = false;

  @override
  Widget build(BuildContext context) {
    final layout = layoutBar(TimeSignature(_beats, _noteValue), _quantize);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Time Signature', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _IntDropdown(
                label: 'Beats',
                values: [for (var beats = 1; beats <= 16; beats++) beats],
                selected: _beats,
                onSelected: (beats) => setState(() => _beats = beats),
              ),
              const Text('/'),
              _IntDropdown(
                label: 'Note value',
                values: const [4, 8],
                selected: _noteValue,
                onSelected: (value) => setState(() => _noteValue = value),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: _zoomedIn ? 'Zoom out' : 'Zoom in',
              icon: Icon(_zoomedIn ? Icons.zoom_out : Icons.zoom_in),
              onPressed: () => setState(() => _zoomedIn = !_zoomedIn),
            ),
          ),
          Timeline(layout: layout, zoomedIn: _zoomedIn),
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

class _IntDropdown extends StatelessWidget {
  const _IntDropdown({
    required this.label,
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<int> values;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      label: Text(label),
      initialSelection: selected,
      requestFocusOnTap: false,
      dropdownMenuEntries: [
        for (final value in values)
          DropdownMenuEntry(value: value, label: '$value'),
      ],
      onSelected: (value) {
        if (value != null) onSelected(value);
      },
    );
  }
}
