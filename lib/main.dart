import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/mpc_sample_helper_app.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final licence = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['RobotoMono'], licence);
  });
  runApp(const MpcSampleHelperApp());
}
