import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hr')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to DEVICEShift app!'**
  String get welcome;

  /// No description provided for @appbar_home.
  ///
  /// In en, this message translates to:
  /// **'DEVICEShift'**
  String get appbar_home;

  /// No description provided for @appbar_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appbar_settings;

  /// No description provided for @appbar_measuring.
  ///
  /// In en, this message translates to:
  /// **'Measuring'**
  String get appbar_measuring;

  /// No description provided for @appbar_results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get appbar_results;

  /// No description provided for @appbar_measurement_details.
  ///
  /// In en, this message translates to:
  /// **'Measurement details'**
  String get appbar_measurement_details;

  /// No description provided for @settings_measurement.
  ///
  /// In en, this message translates to:
  /// **'Measurement settings'**
  String get settings_measurement;

  /// No description provided for @settings_allowed_freq_deviation.
  ///
  /// In en, this message translates to:
  /// **'Allowed frequency deviation:'**
  String get settings_allowed_freq_deviation;

  /// No description provided for @settings_allowed_amp_deviation.
  ///
  /// In en, this message translates to:
  /// **'Allowed amplitude deviation:'**
  String get settings_allowed_amp_deviation;

  /// No description provided for @settings_number_of_readings_per_second.
  ///
  /// In en, this message translates to:
  /// **'Number of readings per second:'**
  String get settings_number_of_readings_per_second;

  /// No description provided for @settings_app_language.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settings_app_language;

  /// No description provided for @settings_croatian.
  ///
  /// In en, this message translates to:
  /// **'Croatian'**
  String get settings_croatian;

  /// No description provided for @settings_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_english;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get stop;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get reset;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'COMPARE'**
  String get compare;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @title_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get title_required;

  /// No description provided for @description_optional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get description_optional;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'EXIT'**
  String get exit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @exit_app.
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get exit_app;

  /// No description provided for @exit_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exit_content;

  /// No description provided for @comparison_successful.
  ///
  /// In en, this message translates to:
  /// **'Comparison successful!'**
  String get comparison_successful;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get error;

  /// No description provided for @device_ok.
  ///
  /// In en, this message translates to:
  /// **'Device is working correctly.'**
  String get device_ok;

  /// No description provided for @device_not_ok.
  ///
  /// In en, this message translates to:
  /// **'Device may not be working properly. It is recommended to check the device.'**
  String get device_not_ok;

  /// No description provided for @allowed_deviation_not_specified.
  ///
  /// In en, this message translates to:
  /// **'Allowed deviation not specified in settings.'**
  String get allowed_deviation_not_specified;

  /// No description provided for @referent_measurement_not_selected.
  ///
  /// In en, this message translates to:
  /// **'Referent measurement is not selected.'**
  String get referent_measurement_not_selected;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @no_measurements_found.
  ///
  /// In en, this message translates to:
  /// **'No measurements found'**
  String get no_measurements_found;

  /// No description provided for @error_saving_data.
  ///
  /// In en, this message translates to:
  /// **'Error saving data. Please try again.'**
  String get error_saving_data;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hr': return AppLocalizationsHr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
