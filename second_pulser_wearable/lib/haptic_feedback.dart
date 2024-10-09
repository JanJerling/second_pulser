import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HapticFeedbackScreen extends StatefulWidget {
  const HapticFeedbackScreen({super.key});

  @override
  State<HapticFeedbackScreen> createState() => _HapticFeedbackScreenState();
}

class _HapticFeedbackScreenState extends State<HapticFeedbackScreen> {
  Timer? _timer;
  bool _isRunning = false;

  void startHapticFeedback() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      triggerHapticFeedback();
    });
  }

  void stopHapticFeedback() {
    _timer?.cancel();
  }

  void triggerHapticFeedback() async {
    HapticFeedback.vibrate();
  }

  void toggleHapticFeedback() {
    setState(() {
      if (_isRunning) {
        stopHapticFeedback();
      } else {
        startHapticFeedback();
      }
      _isRunning = !_isRunning;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: IconButton(
          onPressed: toggleHapticFeedback,
          icon: Icon(
            _isRunning ? Icons.stop : Icons.play_arrow,
            size: 62,
          ),
        ),
      ),
    );
  }
}
