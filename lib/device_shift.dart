import 'package:device_shift/feature/measurement_results/presentation/pages/maesurement_details_screen.dart';
import 'package:device_shift/feature/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'feature/home/presentation/pages/home_screen.dart';
import 'l10n/app_localizations.dart';
import 'main.dart';

class DeviceShift extends StatelessWidget {
  const DeviceShift({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeNotifier,
      builder: (context, locale, _)
      {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DEVICE SHIFT',
          locale: locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale("en"),
            Locale("hr"),
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
            useMaterial3: true,
          ),
          home: const HomeScreen(title: 'DEVICEShift'),
          routes: {
            '/settings': (context) => SettingsScreen(),
            '/measurement_details': (context) => MeasurementDetailsScreen(),
          },
        );
      },
    );
  }
}