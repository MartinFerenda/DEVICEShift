// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get welcome => 'Dobrodošli u DEVICEShift aplikaciju!';

  @override
  String get appbar_home => 'DEVICEShift';

  @override
  String get appbar_settings => 'Postavke';

  @override
  String get appbar_measuring => 'Mjerenje';

  @override
  String get appbar_results => 'Rezultati';

  @override
  String get appbar_measurement_details => 'Pojedinosti mjerenja';

  @override
  String get settings_measurement => 'Postavke mjerenja';

  @override
  String get settings_allowed_freq_deviation => 'Dopuštno odstupanje frekvencije:';

  @override
  String get settings_allowed_amp_deviation => 'Dopušteno odstupanje amplitude:';

  @override
  String get settings_number_of_readings_per_second => 'Broj očitanja po sekundi:';

  @override
  String get settings_app_language => 'Jezik aplikacije';

  @override
  String get settings_croatian => 'Hrvatski';

  @override
  String get settings_english => 'Engleski';

  @override
  String get start => 'POKRENI';

  @override
  String get stop => 'ZAUSTAVI';

  @override
  String get reset => 'PONOVNO POSTAVI';

  @override
  String get compare => 'USPOREDI';

  @override
  String get save => 'SPREMI';

  @override
  String get title => 'Naslov';

  @override
  String get title_required => 'Naslov je obavezan';

  @override
  String get description_optional => 'Opis (neobavezno)';

  @override
  String get description => 'Opis';

  @override
  String get exit => 'IZLAZ';

  @override
  String get cancel => 'ODUSTANI';

  @override
  String get exit_app => 'Izlaz iz aplikacije';

  @override
  String get exit_content => 'Jeste li sigurni da želite izaći?';

  @override
  String get comparison_successful => 'Uspješna usporedba!';

  @override
  String get error => 'Greška!';

  @override
  String get device_ok => 'Uređaj radi ispravno.';

  @override
  String get device_not_ok => 'Uređaj možda ne radi ispravno. Preporuča se pregled uređaja.';

  @override
  String get allowed_deviation_not_specified => 'Dozvoljeno odstupanje nije definirano u postavkama.';

  @override
  String get referent_measurement_not_selected => 'Nije odabrano referntno mjerenje.';

  @override
  String get ok => 'OK';

  @override
  String get no_measurements_found => 'Nema spremljenih mjerenja';

  @override
  String get error_saving_data => 'Greška prilikom spremanja. Molim pokušajte ponovo.';
}
