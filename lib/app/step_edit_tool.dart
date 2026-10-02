import 'package:flutter/material.dart';

import '../model/model.dart';
import 'grid_line_table.dart';
import 'steps_table.dart';
import 'timeline.dart';

class StepEditTool extends StatefulWidget {
  const StepEditTool({super.key});

  @override
  State<StepEditTool> createState() => _StepEditToolState();
}

class _StepEditToolState extends State<StepEditTool> {
  TimeSignature _timeSignature = TimeSignature.standard;
  Quantize _quantize = Quantize.sixteenth;
  bool _zoomedIn = false;

  @override
  Widget build(BuildContext context) {
    final layout = layoutBar(_timeSignature, _quantize);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Dropdown<TimeSignature>(
            label: 'Time Signature',
            values: TimeSignature.values,
            selected: _timeSignature,
            labelOf: (timeSignature) => '$timeSignature',
            onSelected: (timeSignature) =>
                setState(() => _timeSignature = timeSignature),
          ),
          const SizedBox(height: 16),
          _Dropdown<Quantize>(
            label: 'Q',
            values: Quantize.values,
            selected: _quantize,
            labelOf: (quantize) => quantize.label,
            onSelected: (quantize) => setState(() => _quantize = quantize),
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
          StepsTable(key: const Key('steps'), current: _quantize),
        ],
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final String label;
  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      label: Text(label),
      initialSelection: selected,
      requestFocusOnTap: false,
      dropdownMenuEntries: [
        for (final value in values)
          DropdownMenuEntry(value: value, label: labelOf(value)),
      ],
      onSelected: (value) {
        if (value != null) onSelected(value);
      },
    );
  }
}
