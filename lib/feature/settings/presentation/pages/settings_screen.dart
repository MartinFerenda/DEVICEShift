import 'package:device_shift/common/preferences/app_preferences.dart';
import 'package:device_shift/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants/app_screens.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final _formKey = GlobalKey<FormState>();
  final _frequencyController = TextEditingController();
  final _amplitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _loadValues();
    });
  }

  Future<void> _saveSettingsToPrefs() async {
    if (_formKey.currentState!.validate()) {
      final allowedFrequencyDeviation = _frequencyController.text.trim();
      final allowedAmplitudeDeviation = _amplitudeController.text.trim();

      try {
        double frequencyDeviation = double.parse(allowedFrequencyDeviation);
        await AppPreferences.setAllowedFrequencyDeviation(frequencyDeviation);
      } catch (e) {
        AppPreferences.setAllowedFrequencyDeviation(-1.0);
      }
      try {
        double amplitudeDeviation = double.parse(allowedAmplitudeDeviation);
        await AppPreferences.setAllowedAmplitudeDeviation(amplitudeDeviation);
      } catch (e) {
        AppPreferences.setAllowedAmplitudeDeviation(-1.0);
      }
    }
  }

  Future<void> _loadValues() async {
    double? allowedFrequencyDeviation = AppPreferences.getAllowedFrequencyDeviation();
    double? allowedAmplitudeDeviation = AppPreferences.getAllowedAmplitudeDeviation();

    String allowedFreqDeviation = "-";
    String allowedAmpDeviation = "-";

    if (allowedFrequencyDeviation != null) {
      if (allowedFrequencyDeviation.compareTo(0.0) < 0) {
        allowedFreqDeviation = "-";
      } else {
        allowedFreqDeviation = allowedFrequencyDeviation.toString();
      }
    } else {
      allowedFreqDeviation = "-";
    }

    if (allowedAmplitudeDeviation != null) {
      if (allowedAmplitudeDeviation.compareTo(0.0) < 0) {
        allowedAmpDeviation = "-";
      } else {
        allowedAmpDeviation = allowedAmplitudeDeviation.toString();
      }
    } else {
      allowedAmpDeviation = "-";
    }

    setState(() {
      _frequencyController.text = allowedFreqDeviation.toString();
      _amplitudeController.text = allowedAmpDeviation.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentScreen: AppScreens.settings.index),
      body: Padding(padding: EdgeInsets.only(left: 20, right: 35, top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Allowed frequency deviation:"),
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: _frequencyController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          validator: (value) =>
                          value == null || value.trim().isEmpty ? "-1" : null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Allowed amplitude deviation:"),
                      SizedBox(
                        width: 60,
                        child:  TextFormField(
                          controller: _amplitudeController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          validator: (value) =>
                          value == null || value.trim().isEmpty ? "-1" : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent
                    ),
                    onPressed:() async {
                      await _saveSettingsToPrefs();
                      Navigator.pop(context);
                    },
                    child: const Text('SAVE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}