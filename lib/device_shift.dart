import 'package:device_shift/feature/measurement_results/presentation/pages/maesurement_details_screen.dart';
import 'package:device_shift/feature/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';

import 'feature/home/presentation/pages/home_screen.dart';

class DeviceShift extends StatelessWidget {
  const DeviceShift({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEVICE SHIFT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'DEVICEShift'),
      routes: {
        '/settings':(context) => SettingsScreen(),
        '/measurement_details':(context) => MeasurementDetailsScreen(),
      },
    );
  }
}