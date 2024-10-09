import 'package:flutter/material.dart';

import 'haptic_feedback.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Second Pulser',
      darkTheme: ThemeData(
        visualDensity: VisualDensity.compact,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const HapticFeedbackScreen(),
    );
  }
}
