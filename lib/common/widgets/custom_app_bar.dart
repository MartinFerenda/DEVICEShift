import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentScreen;

  const CustomAppBar({super.key, required this.currentScreen});

  String _getTitle(AppLocalizations localizations) {

    switch (currentScreen) {
      case 0:
        return 'DEVICEShift';
      case 1:
        return localizations.appbar_measuring;
      case 2:
        return localizations.appbar_results;
      case 3:
        return localizations.appbar_measurement_details;
      case 4:
        return localizations.appbar_settings;
      default:
        return 'DEVICEShift';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: Colors.greenAccent,
      title: Text(_getTitle(localizations)),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
