import 'package:flutter/material.dart';

class BlockTimerInfo extends ChangeNotifier{
  Duration blockRemainingTime;
  Duration totalRemainingTime;

  Duration getBlockRemainingTime() => blockRemainingTime;
  Duration getTotalRemainingTime() => totalRemainingTime;

  void decreaseTimer(){

    notifyListeners();
  }

  void startTimer(){}

  void pauseTimer(){}
}