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
      this._workoutList.sort((w1,w2) => w1.name.compareTo(w2.name));
      notifyListeners();
    });
  }
  
  void addWorkout(workout) {
    WorkoutDataManager.addWorkout(workout);
    this._workoutList.add(workout);
    this._workoutList.sort((w1,w2) => w1.name.compareTo(w2.name));
    notifyListeners();
  }

  void removeWorkout(Workout workout) {
    WorkoutDataManager.removeWorkout(workout);
    this._workoutList.remove(workout);
    this._workoutList.sort((w1,w2) => w1.name.compareTo(w2.name));
    notifyListeners();
  }

  void updateWorkout(Workout workout, {String name}) {
    if (name != null && name.length > 0)
      workout.name = name;
    WorkoutDataManager.updateWorkout(workout);
    this._workoutList.sort((w1,w2) => w1.name.compareTo(w2.name));
    notifyListeners();
  }
}