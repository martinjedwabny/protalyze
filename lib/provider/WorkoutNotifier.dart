import 'dart:collection';

import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/persistance/WorkoutDataManager.dart';
import 'package:flutter/material.dart';

class WorkoutNotifier extends ChangeNotifier {
  List<Workout> _workoutList = [];

  UnmodifiableListView<Workout> get workouts => UnmodifiableListView(_workoutList);

  void getWorkoutsFromStore() async {
    await WorkoutDataManager.getSavedWorkouts().then((w) {
      this._workoutList = w;
      notifyListeners();
    });
  }
  
  void addWorkout(workout) {
    WorkoutDataManager.addWorkout(workout);
    this._workoutList.add(workout);
    notifyListeners();
  }

  void removeWorkout(Workout workout) {
    WorkoutDataManager.removeWorkout(workout);
    this._workoutList.remove(workout);
    notifyListeners();
  }

  void updateWorkout(Workout workout, {String name}) {
    if (name != null && name.length > 0)
      workout.name = name;
    WorkoutDataManager.updateWorkout(workout);
    notifyListeners();
  }
}