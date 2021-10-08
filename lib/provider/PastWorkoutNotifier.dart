import 'dart:collection';

import 'package:protalyze/common/domain/PastWorkout.dart';
import 'package:protalyze/persistance/PastWorkoutDataManager.dart';
import 'package:flutter/material.dart';

class PastWorkoutNotifier extends ChangeNotifier {
  List<PastWorkout> _pastWorkoutList = [];

  UnmodifiableListView<PastWorkout> get pastWorkouts => UnmodifiableListView(_pastWorkoutList);

  Future<void> getPastWorkoutsFromStore() async {
    await PastWorkoutDataManager.getSavedPastWorkouts().then((pw) {
      this._pastWorkoutList = pw;
      notifyListeners();
    });
  }

  Future<void> addPastWorkout(PastWorkout pastWorkout) async {
    this._pastWorkoutList.add(pastWorkout);
    notifyListeners();
    await PastWorkoutDataManager.addPastWorkout(pastWorkout);
  }

  Future<void> removePastWorkout(PastWorkout pastWorkout) async {
    this._pastWorkoutList.remove(pastWorkout);
    notifyListeners();
    await PastWorkoutDataManager.removePastWorkout(pastWorkout);
  }

  Future<void> updatePastWorkout(PastWorkout pastWorkout, {String name, DateTime date, String notes}) async {
    if (name != null && name.length > 0)
      pastWorkout.workout.name = name;
    if (date != null)
      pastWorkout.dateTime = date;
    if (notes != null)
      pastWorkout.notes = notes;
    notifyListeners();
    await PastWorkoutDataManager.updatePastWorkout(pastWorkout);
  }
}