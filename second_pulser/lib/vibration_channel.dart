import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VibrationChannel {
  static const MethodChannel _channel = MethodChannel('vibration_channel');

  static Future<void> customVibrate() async {
    try {
      await _channel.invokeMethod('customVibrate');
    } on PlatformException catch (e) {
      debugPrint("Failed to invoke: '${e.message}'.");
    }
  }
}
