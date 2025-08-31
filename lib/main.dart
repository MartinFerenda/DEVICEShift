import 'package:device_shift/device_shift.dart';
import 'package:flutter/material.dart';

import 'common/preferences/app_preferences.dart';

final localeNotifier = ValueNotifier<Locale?>(null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  final String? languageCode = AppPreferences.getLanguage();
  if (languageCode != null) {
    localeNotifier.value = Locale(languageCode);
  } else {
    localeNotifier.value = Locale("hr");
    AppPreferences.setLanguage("hr");
  }
  runApp(DeviceShift());
}