import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

Finder stepsText(String text) => find.descendant(
  of: find.byKey(const Key('steps')),
  matching: find.text(text),
);

Color? highlightColour(WidgetTester tester) =>
    HelperColors.of(tester.element(find.byType(StepEditTool))).highlight;

Color? textColour(WidgetTester tester, Finder finder) =>
    tester.widget<Text>(finder).style?.color;

/// The colour the text is actually drawn in, after theme defaults.
Color? renderedColour(WidgetTester tester, Finder finder) =>
    tester.renderObject<RenderParagraph>(finder).text.style?.color;

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

final timeSignatureDropdown = find.byType(DropdownMenu<TimeSignature>);

Future<void> chooseTimeSignature(WidgetTester tester, String label) async {
  await tester.tap(timeSignatureDropdown);
  await tester.pumpAndSettle();
  await tapMenuItem(tester, label);
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

  testWidgets(
    'the app is dark with Roboto Mono even when the system is light',
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(const MpcSampleHelperApp());
      final theme = Theme.of(tester.element(find.byType(StepEditTool)));

      expect(theme.brightness, Brightness.dark);
      expect(theme.textTheme.bodyMedium!.fontFamily, 'RobotoMono');
    },
  );

  testWidgets('the selected tab is blue and field labels are amber', (
    tester,
  ) async {
    await tester.pumpWidget(const MpcSampleHelperApp());
    final bar = find.byType(NavigationBar);

    expect(
      renderedColour(
        tester,
        find.descendant(of: bar, matching: find.text('STEP EDIT')),
      ),
      DevicePalette.blue,
    );
    expect(
      renderedColour(
        tester,
        find.descendant(of: bar, matching: find.text('Shortcuts')),
      ),
      isNot(DevicePalette.blue),
    );
    expect(
      renderedColour(tester, find.text('Time Signature').first),
      DevicePalette.amber,
    );
    expect(renderedColour(tester, find.text('Steps')), DevicePalette.amber);
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

  testWidgets('Steps highlights the current Q', (tester) async {
    await tester.pumpWidget(const MpcSampleHelperApp());
    final highlight = highlightColour(tester);

    expect(find.text('Steps'), findsOneWidget);
    expect(textColour(tester, stepsText('240')), highlight);
    expect(textColour(tester, stepsText('960')), isNot(highlight));

    await chooseQ(tester, '1/4');

    expect(textColour(tester, stepsText('960')), highlight);
    expect(textColour(tester, stepsText('240')), isNot(highlight));
  });

  testWidgets('Time Signature offers the device\'s values, defaulting to 4/4', (
    tester,
  ) async {
    await tester.pumpWidget(const MpcSampleHelperApp());

    final dropdown = tester.widget<DropdownMenu<TimeSignature>>(
      timeSignatureDropdown,
    );
    expect((dropdown.label! as Text).data, 'Time Signature');
    expect(dropdown.initialSelection, TimeSignature.fourFour);
    expect(
      [for (final entry in dropdown.dropdownMenuEntries) entry.label],
      [
        '2/4', '3/4', '4/4', '5/4', '6/4', '7/4', //
        '6/8', '7/8', '9/8', '10/8', '11/8', '12/8',
      ],
    );
  });

  testWidgets('choosing 6/8 counts six eighth-note Beats', (tester) async {
    await tester.pumpWidget(const MpcSampleHelperApp());

    await chooseTimeSignature(tester, '6/8');

    expect(gridLineTableText('1:240'), findsOneWidget);
    expect(gridLineTableText('2:000'), findsOneWidget);
    expect(gridLineTableText('6:240'), findsOneWidget);
    expect(gridLineTableText('1:480'), findsNothing);
    expect(gridLineTableText('7:000'), findsNothing);
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
