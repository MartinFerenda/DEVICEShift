import 'package:device_shift/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants/app_screens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentScreen: AppScreens.settings.index),
      body: const Center(
        child: Text('This is the Settings screen'),
      ),
    );
  }
}