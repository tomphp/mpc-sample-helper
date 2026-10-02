import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/app/mpc_sample_helper_app.dart';

void main() {
  testWidgets('launches on STEP EDIT with STEP EDIT and Shortcuts tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const MpcSampleHelperApp());

    final bar = find.byType(NavigationBar);
    expect(
      find.descendant(of: bar, matching: find.text('STEP EDIT')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: bar, matching: find.text('Shortcuts')),
      findsOneWidget,
    );
    expect(tester.widget<NavigationBar>(bar).selectedIndex, 0);
  });

  testWidgets('Shortcuts shows its intro sentence', (tester) async {
    await tester.pumpWidget(const MpcSampleHelperApp());

    await tester.tap(find.text('Shortcuts'));
    await tester.pumpAndSettle();

    expect(
      find.text('A list of shortcuts that are not labelled on the front panel.'),
      findsOneWidget,
    );
  });
}
