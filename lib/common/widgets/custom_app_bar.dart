import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentScreen;

  const CustomAppBar({super.key, required this.currentScreen});

  String _getTitle() {
    switch (currentScreen) {
      case 0:
        return 'DEVICEShift';
      case 1:
        return 'Measuring';
      case 2:
        return 'Results';
      case 3:
        return 'Result details';
      case 4:
        return 'Settings';
      default:
        return 'DEVICEShift';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      title: Text(_getTitle()),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
