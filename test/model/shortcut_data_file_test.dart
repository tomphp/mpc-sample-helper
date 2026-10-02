import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('the bundled Shortcut data file parses', () {
    final modes = parseShortcuts(
      File('assets/shortcuts.yaml').readAsStringSync(),
    );

    expect(modes, isNotEmpty);
    expect(modes.expand((mode) => mode.shortcuts), isNotEmpty);
  });
}
