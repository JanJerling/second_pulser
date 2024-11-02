import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';

import 'vibration_channel.dart';

class HapticFeedbackScreen extends StatefulWidget {
  const HapticFeedbackScreen({super.key});

  @override
  State<HapticFeedbackScreen> createState() => _HapticFeedbackScreenState();
}

class _HapticFeedbackScreenState extends State<HapticFeedbackScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _isRunning = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ).drive(Tween<double>(begin: 100, end: 0));
  }

  void startHapticFeedback() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      triggerHapticFeedback();
    });
  }

  void stopHapticFeedback() {
    _timer?.cancel();
  }

  void triggerHapticFeedback() {
    HapticFeedback.vibrate();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
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
    );
  }
}
