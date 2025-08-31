import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/round_exit_button.dart';
import '../widgets/round_settings_button.dart';

class HomeScreenDetails extends StatelessWidget {
  const HomeScreenDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RoundSettingsButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                RoundExitButton(
                  onPressed: () {
                    _showExitDialog(context, localizations);
                  },
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                localizations.welcome,
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.greenAccent
              //   ),
              //   onPressed: () {
              //     final navigationState = navigationKey.currentState!;
              //     navigationState.setPage(2);
              //   },
              //   child: Text(
              //       'Go to results'
              //   ),
              // ),
            ],
          ),
        ]
      ),
    );
  }

  void _showExitDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localizations.exit_app),
        content: Text(localizations.exit_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            child: Text(localizations.exit),
          ),
        ],
      ),
    );
  }
}