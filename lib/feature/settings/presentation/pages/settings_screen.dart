import 'package:device_shift/common/preferences/app_preferences.dart';
import 'package:device_shift/common/widgets/custom_app_bar.dart';
import 'package:device_shift/main.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants/app_screens.dart';
import '../../../../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final _formKey = GlobalKey<FormState>();
  final _frequencyController = TextEditingController();
  final _amplitudeController = TextEditingController();
  final _measurementsPerSecondController = TextEditingController();
  String appLanguage = "";

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
      final measurementsPerSecond = _measurementsPerSecondController.text.trim();

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
      try {
        int numberOfMeasurementsPerSecond = int.parse(measurementsPerSecond);
        await AppPreferences.setNumberOfMeasurementsPerSecond(numberOfMeasurementsPerSecond);
      } catch (e) {
        AppPreferences.setNumberOfMeasurementsPerSecond(0);
      }
      AppPreferences.setLanguage(appLanguage);
    }
  }

  Future<void> _loadValues() async {
    double? allowedFrequencyDeviation = AppPreferences.getAllowedFrequencyDeviation();
    double? allowedAmplitudeDeviation = AppPreferences.getAllowedAmplitudeDeviation();
    int? numberOfMeasurementsPerSecond = AppPreferences.getNumberOfMeasurementsPerSecond();
    String? prefsAppLanguage = AppPreferences.getLanguage();

    String allowedFreqDeviation = "-";
    String allowedAmpDeviation = "-";
    String numberOfMeasurementsPerSec = "-";

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

    if (numberOfMeasurementsPerSecond != null) {
      if (numberOfMeasurementsPerSecond.compareTo(0) < 0) {
        numberOfMeasurementsPerSec = "-";
      } else {
        numberOfMeasurementsPerSec = numberOfMeasurementsPerSecond.toString();
      }
    } else {
      numberOfMeasurementsPerSec = "-";
    }

    setState(() {
      _frequencyController.text = allowedFreqDeviation.toString();
      _amplitudeController.text = allowedAmpDeviation.toString();
      _measurementsPerSecondController.text = numberOfMeasurementsPerSec.toString();
      if (prefsAppLanguage != null) {
        appLanguage = prefsAppLanguage;
      }
    });
  }

  void _changeAppLanguage(BuildContext context, Locale locale) {
    AppPreferences.setLanguage(appLanguage);
    localeNotifier.value = locale;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(currentScreen: AppScreens.settings.index),
      body: Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: 18, right: 0, top: 0, bottom: 0),
              child: Text(localizations.settings_measurement),
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsetsGeometry.only(left: 0, right: 0, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.greenAccent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(localizations.settings_allowed_freq_deviation),
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              controller: _frequencyController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              validator: (value) =>
                              value == null || value.trim().isEmpty ? "-1" : null,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.greenAccent,
                                    width: 3.0,
                                  )
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(localizations.settings_allowed_amp_deviation),
                          SizedBox(
                            width: 60,
                            child:  TextFormField(
                              controller: _amplitudeController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              validator: (value) =>
                              value == null || value.trim().isEmpty ? "-1" : null,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.greenAccent,
                                    width: 3.0,
                                  )
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(localizations.settings_number_of_readings_per_second),
                          SizedBox(
                            width: 60,
                            child:  TextFormField(
                              controller: _measurementsPerSecondController,
                              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                              textAlign: TextAlign.center,
                              validator: (value) =>
                              value == null || value.trim().isEmpty ? "0" : null,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.greenAccent,
                                    width: 3.0,
                                  )
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(left: 18, right: 0, top: 0, bottom: 0),
              child: Text(localizations.settings_app_language),
            ),
            Container(
              margin: EdgeInsetsGeometry.only(left: 0, right: 0, top: 10, bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.greenAccent,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 3, right: 0, top: 0, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child:
                            RadioMenuButton(
                              value: 'hr',
                              groupValue: appLanguage,
                              onChanged: (selectedLanguage) {
                                setState(() {
                                  appLanguage = selectedLanguage!;
                                  _changeAppLanguage(context, Locale(appLanguage));
                                });
                              },
                              child: Text(localizations.settings_croatian),
                            ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 3, right: 0, top: 0, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child:
                          RadioMenuButton(
                            value: 'en',
                            groupValue: appLanguage,
                            onChanged: (selectedLanguage) {
                              setState(() {
                                appLanguage = selectedLanguage!;
                                _changeAppLanguage(context, Locale(appLanguage));
                              });
                            },
                            child: Text(localizations.settings_english),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Text(localizations.save),
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