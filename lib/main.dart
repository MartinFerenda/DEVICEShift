import 'package:device_shift/device_shift.dart';
import 'package:flutter/material.dart';

import 'common/preferences/app_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  runApp(const DeviceShift());
}