import 'package:flutter/material.dart';

import '../model/model.dart';
import 'theme.dart';

/// Every Grid Line in the Bar with its Position and, if it lands on one,
/// its Beat.
class GridLineTable extends StatelessWidget {
  const GridLineTable({super.key, required this.gridLines});

  final List<GridLine> gridLines;

  @override
  Widget build(BuildContext context) {
    final highlight = HelperColors.of(context).highlight;
    return DataTable(
      columns: const [
        DataColumn(label: Text('Grid Line'), numeric: true),
        DataColumn(label: Text('Position')),
        DataColumn(label: Text('Beat'), numeric: true),
      ],
      rows: [
        for (final line in gridLines)
          DataRow(
            cells: [
              DataCell(Text('${line.number}')),
              DataCell(
                Text(
                  '${line.position}',
                  style: line.position.isInexact
                      ? TextStyle(color: highlight, fontWeight: FontWeight.bold)
                      : null,
                ),
              ),
              DataCell(Text(line.beat == null ? '' : '${line.beat}')),
            ],
          ),
      ],
    );
  }
}
