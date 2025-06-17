import 'package:flutter/material.dart';

class RoundSettingsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RoundSettingsButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
        backgroundColor: Colors.greenAccent,
      ),
      child: const Icon(
        Icons.settings,
        size: 40,
        color: Colors.black87,
      ),
    );
  }
}
