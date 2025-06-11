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
    );
  }
}