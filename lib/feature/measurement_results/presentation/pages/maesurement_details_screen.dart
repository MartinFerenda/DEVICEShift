import 'package:flutter/material.dart';

import '../../../../common/constants/app_screens.dart';
import '../../../../common/widgets/custom_app_bar.dart';

class MeasurementDetailsScreen extends StatelessWidget {
  const MeasurementDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentScreen: AppScreens.resultDetails.index),
      body: const Center(
        child: Text('This is the Details screen'),
      ),
    );
  }
}