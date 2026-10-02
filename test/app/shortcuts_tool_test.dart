import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/app/mpc_sample_helper_app.dart';
import 'package:mpc_sample_helper/app/theme.dart';

/// Serves [shortcuts] as the Shortcut data file.
class _ShortcutBundle extends CachingAssetBundle {
  _ShortcutBundle(this.shortcuts);

  final String shortcuts;

  @override
  Future<ByteData> load(String key) async {
    if (key != 'assets/shortcuts.yaml') return rootBundle.load(key);
    return ByteData.sublistView(utf8.encode(shortcuts));
  }
}

const _testShortcuts = '''
modes:
  - mode: Any Mode
    shortcuts:
      - gesture:
          - press twice: STOP
        effect: Stop all audio
  - mode: Sample Mode
    shortcuts:
      - gesture:
          - hold: SAMPLE
          - press: any pad
        condition: while stopped
        effect: Select the pad without playing it
''';

Future<void> openShortcuts(WidgetTester tester) async {
  await tester.pumpWidget(
    DefaultAssetBundle(
      bundle: _ShortcutBundle(_testShortcuts),
      child: const MpcSampleHelperApp(),
    ),
  );
  await tester.tap(find.text('Shortcuts'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists Shortcuts under their Mode headings in order', (
    tester,
  ) async {
    await openShortcuts(tester);

    expect(
      find.text(
        'A list of shortcuts that are not labelled on the front panel.',
      ),
      findsOneWidget,
    );
    final anyMode = tester.getTopLeft(find.text('Any Mode')).dy;
    final stopAll = tester.getTopLeft(find.text('Stop all audio')).dy;
    final sampleMode = tester.getTopLeft(find.text('Sample Mode')).dy;
    final selectPad = tester
        .getTopLeft(find.text('Select the pad without playing it'))
        .dy;
    expect(
      tester
          .renderObject<RenderParagraph>(find.text('Any Mode'))
          .text
          .style
          ?.color,
      DevicePalette.amber,
    );
    expect(anyMode, lessThan(stopAll));
    expect(stopAll, lessThan(sampleMode));
    expect(sampleMode, lessThan(selectPad));
  });

  testWidgets('shows each Gesture as keycaps with action words', (
    tester,
  ) async {
    await openShortcuts(tester);

    expect(find.text('■'), findsOneWidget);
    expect(find.text('press twice'), findsOneWidget);
    expect(find.text('SAMPLE'), findsOneWidget);
    expect(find.text('hold'), findsOneWidget);
    expect(find.text('press'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
    expect(find.text('while stopped'), findsOneWidget);
  });
}
