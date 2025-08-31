// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome to DEVICEShift app!';

  @override
  String get appbar_home => 'DEVICEShift';

  @override
  String get appbar_settings => 'Settings';

  @override
  String get appbar_measuring => 'Measuring';

  @override
  String get appbar_results => 'Results';

  @override
  String get appbar_measurement_details => 'Measurement details';

  @override
  String get settings_measurement => 'Measurement settings';

  @override
  String get settings_allowed_freq_deviation => 'Allowed frequency deviation:';

  @override
  String get settings_allowed_amp_deviation => 'Allowed amplitude deviation:';

  @override
  String get settings_number_of_readings_per_second => 'Number of readings per second:';

  @override
  String get settings_app_language => 'App language';

  @override
  String get settings_croatian => 'Croatian';

  @override
  String get settings_english => 'English';

  @override
  String get start => 'START';

  @override
  String get stop => 'STOP';

  @override
  String get reset => 'RESET';

  @override
  String get compare => 'COMPARE';

  @override
  String get save => 'SAVE';

  @override
  String get title => 'Title';

  @override
  String get title_required => 'Title is required';

  @override
  String get description_optional => 'Description (optional)';

  @override
  String get description => 'Description';

  @override
  String get exit => 'EXIT';

  @override
  String get cancel => 'CANCEL';

  @override
  String get exit_app => 'Exit app';

  @override
  String get exit_content => 'Are you sure you want to exit?';

  @override
  String get comparison_successful => 'Comparison successful!';

  @override
  String get error => 'Error!';

  @override
  String get device_ok => 'Device is working correctly.';

  @override
  String get device_not_ok => 'Device may not be working properly. It is recommended to check the device.';

  @override
  String get allowed_deviation_not_specified => 'Allowed deviation not specified in settings.';

  @override
  String get referent_measurement_not_selected => 'Referent measurement is not selected.';

  @override
  String get ok => 'OK';

  @override
  String get no_measurements_found => 'No measurements found';

  @override
  String get error_saving_data => 'Error saving data. Please try again.';
}
