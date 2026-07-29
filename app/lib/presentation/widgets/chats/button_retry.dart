import 'package:flutter/material.dart';

class RestartButton extends StatelessWidget {
  final VoidCallback onRestart;

  const RestartButton({
    super.key,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ElevatedButton.icon(
          onPressed: onRestart,
          icon: const Icon(Icons.refresh),
          label: const Text("Ulangi Analisis"),
        ),
      ),
    );
  }
}