import 'dart:async';

import 'package:flutter/material.dart';

class TimerNotifier extends ChangeNotifier {
  Stopwatch _watch;
  Timer _timer;
  Duration _elapsedDuration;
  Duration _totalDuration;

  Duration get remainingTime => _totalDuration - _elapsedDuration;

  bool get isRunning => _timer != null && _timer.isActive;

  TimerNotifier(Duration duration) {
    _watch = Stopwatch();
    _totalDuration = duration;
  }

  void start() {
    if (_timer == null) 
      _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _watch.start();
  }

  void _onTick(Timer timer) {
    _elapsedDuration = _watch.elapsed;
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
    _elapsedDuration = _watch.elapsed;
  }
}