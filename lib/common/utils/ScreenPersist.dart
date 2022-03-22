import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wakelock/wakelock.dart';

class ScreenPersist {
  static bool supportedPlatform =
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static void enable() {
    if (!supportedPlatform) return;
    try {
      Wakelock.enable();
    } catch (e) {
      print(e);
    }
  }

  static void disable() {
    if (!supportedPlatform) return;
    try {
      Wakelock.disable();
    } catch (e) {
      print(e);
    }
  }
}
