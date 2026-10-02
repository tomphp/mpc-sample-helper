import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/app/keycap.dart';
import 'package:mpc_sample_helper/app/mpc_sample_helper_app.dart';

/// Serves [tips] as the Tip data file.
class _TipBundle extends CachingAssetBundle {
  _TipBundle(this.tips);

  final String tips;

  @override
  Future<ByteData> load(String key) async {
    if (key != 'assets/tips.yaml') return rootBundle.load(key);
    return ByteData.sublistView(utf8.encode(tips));
  }
}

const _testTips = '''
tips:
  - title: Resample a live performance
    outcome: Capture a performance as a sample
    steps:
      - Set Source to Resample
      - Play live
  - title: Layer two pads
    outcome: One pad also triggers another
    steps:
      - Select the pad
    note: Only within the same Pad Bank
''';

Future<void> openTips(WidgetTester tester, [String tips = _testTips]) async {
  await tester.pumpWidget(
    DefaultAssetBundle(
      bundle: _TipBundle(tips),
      child: const MpcSampleHelperApp(),
    ),
  );
  await tester.tap(find.text('Tips & Tricks'));
  await tester.pumpAndSettle();
}

Finder richText(String text) => find.text(text, findRichText: true);

double top(WidgetTester tester, Finder finder) => tester.getTopLeft(finder).dy;

void main() {
  testWidgets('shows its intro sentence', (tester) async {
    await openTips(tester);

    expect(
      find.text(
        'Workflows that combine features to do something more advanced.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('lists Tips in order with outcome, numbered steps and note', (
    tester,
  ) async {
    await openTips(tester);

    final inOrder = [
      find.text('Resample a live performance'),
      find.text('Capture a performance as a sample'),
      richText('Set Source to Resample'),
      richText('Play live'),
      find.text('Layer two pads'),
      find.text('One pad also triggers another'),
      richText('Select the pad'),
      richText('Only within the same Pad Bank'),
    ];
    for (final (index, finder) in inOrder.indexed.skip(1)) {
      expect(
        top(tester, inOrder[index - 1]),
        lessThan(top(tester, finder)),
        reason: '$finder',
      );
    }
    // Only the second Tip has a note.
    expect(find.byKey(const Key('tip-note')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('tip-note')),
        matching: richText('Only within the same Pad Bank'),
      ),
      findsOneWidget,
    );
    expect(find.text('1.'), findsNWidgets(2));
    expect(find.text('2.'), findsOneWidget);
    expect(top(tester, find.text('2.')), top(tester, richText('Play live')));
    expect(
      tester.getTopLeft(find.text('2.')).dx,
      lessThan(tester.getTopLeft(richText('Play live')).dx),
    );
  });

  testWidgets('draws bracketed Controls as keycaps among the words', (
    tester,
  ) async {
    await openTips(tester, '''
tips:
  - title: Stop everything
    outcome: Silence
    steps:
      - Hold [SHIFT] and tap [STOP] twice, then [pad 14]
''');

    expect(find.text('SHIFT'), findsOneWidget);
    expect(find.text('■'), findsOneWidget);
    expect(find.textContaining('and tap', findRichText: true), findsOneWidget);
    expect(find.textContaining('[', findRichText: true), findsNothing);
    final hold = tester.getTopLeft(find.text('SHIFT')).dx;
    final stop = tester.getTopLeft(find.text('■')).dx;
    expect(hold, lessThan(stop));
    // Inline keycaps stay close to the height of a line of text.
    for (final label in ['SHIFT', '■', '14']) {
      final keycap = find.ancestor(
        of: find.text(label),
        matching: find.byType(ControlKeycap),
      );
      expect(tester.getSize(keycap).height, lessThanOrEqualTo(30));
    }
    // Inline keycaps carry no action word above them.
    expect(find.text('press'), findsNothing);
    expect(find.text('hold'), findsNothing);
  });

  testWidgets('shows a malformed Tip data file\'s error', (tester) async {
    await openTips(tester, '''
tips:
  - title: Broken
    outcome: Nothing
    steps: ["Turn [K4]"]
''');

    expect(find.textContaining('unknown Control "K4"'), findsOneWidget);
  });
}
