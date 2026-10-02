import 'package:flutter/material.dart';

import '../model/model.dart';
import 'keycap.dart';
import 'theme.dart';

/// Shortcuts grouped by Mode, read from the bundled Shortcut data file.
class ShortcutsTool extends StatefulWidget {
  const ShortcutsTool({super.key});

  @override
  State<ShortcutsTool> createState() => _ShortcutsToolState();
}

class _ShortcutsToolState extends State<ShortcutsTool> {
  Future<List<ShortcutMode>>? _modes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _modes ??= DefaultAssetBundle.of(context)
        .loadString('assets/shortcuts.yaml')
        .then(parseShortcuts);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _modes,
      builder: (context, snapshot) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'A list of shortcuts that are not labelled on the front panel.',
          ),
          if (snapshot.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                '${snapshot.error}',
                style: HelperColors.of(context).highlightStyle,
              ),
            ),
          for (final mode in snapshot.data ?? const <ShortcutMode>[]) ...[
            const SizedBox(height: 24),
            Text(
              mode.name,
              style: Theme.of(context).textTheme.titleMedium!
                  .copyWith(color: HelperColors.of(context).label),
            ),
            for (final shortcut in mode.shortcuts)
              _ShortcutEntry(shortcut: shortcut),
          ],
        ],
      ),
    );
  }
}

class _ShortcutEntry extends StatelessWidget {
  const _ShortcutEntry({required this.shortcut});

  final Shortcut shortcut;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DevicePalette.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              for (final (index, step) in shortcut.gesture.indexed) ...[
                if (index > 0)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text('+'),
                  ),
                Keycap(step: step),
              ],
            ],
          ),
          if (shortcut.condition case final condition?) ...[
            const SizedBox(height: 8),
            Text(condition, style: TextStyle(color: muted)),
          ],
          const SizedBox(height: 8),
          Text(shortcut.effect),
        ],
      ),
    );
  }
}
