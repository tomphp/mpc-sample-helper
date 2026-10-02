import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/app/mpc_sample_helper_app.dart';
import 'package:mpc_sample_helper/app/step_edit_tool.dart';
import 'package:mpc_sample_helper/app/theme.dart';
import 'package:mpc_sample_helper/app/timeline.dart';
import 'package:mpc_sample_helper/model/model.dart';

Finder gridLineTableText(String text) => find.descendant(
  of: find.byKey(const Key('grid-line-table')),
  matching: find.text(text),
);

Finder standardStepsText(String text) => find.descendant(
  of: find.byKey(const Key('standard-steps')),
  matching: find.text(text),
);

Color? highlightColour(WidgetTester tester) =>
    HelperColors.of(tester.element(find.byType(StepEditTool))).highlight;

Color? textColour(WidgetTester tester, Finder finder) =>
    tester.widget<Text>(finder).style?.color;

Future<void> tapMenuItem(WidgetTester tester, String label) async {
  final item = find.widgetWithText(MenuItemButton, label).last;
  await tester.ensureVisible(item);
  await tester.pumpAndSettle();
  await tester.tap(item);
  await tester.pumpAndSettle();
}

final qDropdown = find.byType(DropdownMenu<Quantize>);

Future<void> chooseQ(WidgetTester tester, String label) async {
  await tester.tap(qDropdown);
  await tester.pumpAndSettle();
  await tapMenuItem(tester, label);
}

Finder timeSignatureDropdown(String label) => find.byWidgetPredicate(
  (widget) =>
      widget is DropdownMenu<int> && (widget.label as Text?)?.data == label,
);

Future<void> chooseTimeSignature(
  WidgetTester tester,
  int beats,
  int noteValue,
) async {
  for (final (label, value) in [('Beats', beats), ('Note value', noteValue)]) {
    await tester.tap(timeSignatureDropdown(label));
    await tester.pumpAndSettle();
    await tapMenuItem(tester, '$value');
  }
}

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

  testWidgets('STEP EDIT starts at Q 1/16 and lists its Grid Lines', (
    tester,
  ) async {
    await tester.pumpWidget(const MpcSampleHelperApp());

    final label = tester.widget<DropdownMenu<Quantize>>(qDropdown).label;
    expect((label! as Text).data, 'Q');
    expect(gridLineTableText('1:000'), findsOneWidget);
    expect(gridLineTableText('1:240'), findsOneWidget);
    expect(gridLineTableText('4:720'), findsOneWidget);
  });

  testWidgets('changing Q updates the Grid Line table', (tester) async {
    await tester.pumpWidget(const MpcSampleHelperApp());

    await chooseQ(tester, '1/4');

    expect(gridLineTableText('1:240'), findsNothing);
    expect(gridLineTableText('2:000'), findsOneWidget);
    expect(gridLineTableText('4:000'), findsOneWidget);
  });

  testWidgets('Standard Steps in 4/4 highlights the current Q', (tester) async {
    await tester.pumpWidget(const MpcSampleHelperApp());
    final highlight = highlightColour(tester);

    expect(find.text('Standard Steps in 4/4'), findsOneWidget);
    expect(textColour(tester, standardStepsText('240')), highlight);
    expect(textColour(tester, standardStepsText('960')), isNot(highlight));

    await chooseQ(tester, '1/4');

    expect(textColour(tester, standardStepsText('960')), highlight);
    expect(textColour(tester, standardStepsText('240')), isNot(highlight));
  });

  testWidgets('Time Signature defaults to 4/4 and emulates 3/4', (
    tester,
  ) async {
    await tester.pumpWidget(const MpcSampleHelperApp());

    expect(
      tester
          .widget<DropdownMenu<int>>(timeSignatureDropdown('Beats'))
          .initialSelection,
      4,
    );
    expect(
      tester
          .widget<DropdownMenu<int>>(timeSignatureDropdown('Note value'))
          .initialSelection,
      4,
    );

    await chooseTimeSignature(tester, 3, 4);
    await chooseQ(tester, '1/4');

    expect(gridLineTableText('1:000'), findsOneWidget);
    expect(gridLineTableText('2:320'), findsOneWidget);
    expect(gridLineTableText('3:640'), findsOneWidget);
    expect(gridLineTableText('4:000'), findsNothing);
  });

  testWidgets('Inexact rows are highlighted', (tester) async {
    await tester.pumpWidget(const MpcSampleHelperApp());
    final highlight = highlightColour(tester);

    await chooseTimeSignature(tester, 3, 4);
    await chooseQ(tester, '1/8T');

    expect(textColour(tester, gridLineTableText('1:426.7')), highlight);
    expect(textColour(tester, gridLineTableText('2:320')), isNot(highlight));

    // Grid Line 5 (2:746.7) is Inexact; Grid Line 4 (2:320) is not.
    expect(textColour(tester, gridLineTableText('5')), highlight);
    expect(textColour(tester, gridLineTableText('4')), isNot(highlight));
  });

  testWidgets('the zoom button switches the Timeline between views', (
    tester,
  ) async {
    await tester.pumpWidget(const MpcSampleHelperApp());
    final horizontallyScrollingTimeline = find.descendant(
      of: find.byType(Timeline),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.right,
      ),
    );

    expect(horizontallyScrollingTimeline, findsNothing);

    await tester.tap(find.byTooltip('Zoom in'));
    await tester.pumpAndSettle();

    expect(horizontallyScrollingTimeline, findsOneWidget);
    expect(find.byTooltip('Zoom out'), findsOneWidget);
    expect(gridLineTableText('1:240'), findsOneWidget);

    await tester.tap(find.byTooltip('Zoom out'));
    await tester.pumpAndSettle();

    expect(horizontallyScrollingTimeline, findsNothing);
    expect(gridLineTableText('1:240'), findsOneWidget);
  });

  testWidgets('Shortcuts shows its intro sentence', (tester) async {
    await tester.pumpWidget(const MpcSampleHelperApp());

    await tester.tap(find.text('Shortcuts'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'A list of shortcuts that are not labelled on the front panel.',
      ),
      findsOneWidget,
    );
  });
}
