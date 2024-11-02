import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';

class HapticFeedbackScreen extends StatefulWidget {
  const HapticFeedbackScreen({super.key});

  @override
  State<HapticFeedbackScreen> createState() => _HapticFeedbackScreenState();
}

class _HapticFeedbackScreenState extends State<HapticFeedbackScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  Timer? _clockTimer;
  String currentTime = DateFormat('HH:mm').format(DateTime.now());
  bool _isRunning = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation for start stop shadow effect
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuint,
    ).drive(Tween<double>(begin: 100, end: 0));

    // Set the initial time
    setState(() {
      currentTime = DateFormat('HH:mm').format(DateTime.now());
    });

    // Start the clock timer
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.second == 0) {
        setState(() {
          currentTime = DateFormat('HH:mm').format(now);
        });
      }
    });
  }

  void startHapticFeedback() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      triggerHapticFeedback();
    });
  }

  void stopHapticFeedback() {
    _timer?.cancel();
  }

  void triggerHapticFeedback() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 255);
    }
  }

  void toggleHapticFeedback() {
    setState(() {
      if (_isRunning) {
        stopHapticFeedback();
        ForegroundService().stop();
        _animationController.stop();
      } else {
        startHapticFeedback();
        ForegroundService().start();
        _animationController.repeat();
      }
      _isRunning = !_isRunning;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    ForegroundService().start();
    _animationController.dispose();
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return IconButton(
                onPressed: toggleHapticFeedback,
                icon: Icon(
                  _isRunning ? Icons.stop : Icons.play_arrow,
                  size: 62,
                  shadows: _isRunning
                      ? [
                          Shadow(
                            blurRadius: _animation.value,
                            color: Colors.white,
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              currentTime,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
