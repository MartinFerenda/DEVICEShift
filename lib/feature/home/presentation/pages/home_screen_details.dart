import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/round_exit_button.dart';
import '../widgets/round_settings_button.dart';

class HomeScreenDetails extends StatelessWidget {
  const HomeScreenDetails({super.key});

  @override
  Widget build(BuildContext context) {
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
                    _showExitDialog(context);
                  },
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to DEVICEShift app!',
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

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }
}