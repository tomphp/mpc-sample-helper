import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_sample_helper/model/model.dart';

void main() {
  test('the bundled Tip data file parses', () {
    final tips = parseTips(File('assets/tips.yaml').readAsStringSync());

    expect(tips, isNotEmpty);
  });
}
