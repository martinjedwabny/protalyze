import 'dart:collection';

import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:protalyze/persistance/ExerciseDataManager.dart';
import 'package:flutter/material.dart';

class ExerciseNotifier extends ChangeNotifier {
  List<ExerciseBlock> _exerciseList = [];

  UnmodifiableListView<ExerciseBlock> get exercises => UnmodifiableListView(_exerciseList);

  void getExerciseBlocksFromStore() async {
    await ExerciseDataManager.getSavedExerciseBlocks().then((w) {
      this._exerciseList = w;
      this._exerciseList.sort((w1,w2) => w1.name.compareTo(w2.name));
      notifyListeners();
    });
  }
  
  void addExerciseBlock(exercise) {
    ExerciseDataManager.addExerciseBlock(exercise);
    this._exerciseList.add(exercise);
    this._exerciseList.sort((w1,w2) => w1.name.compareTo(w2.name));
    notifyListeners();
  }

  void removeExerciseBlock(ExerciseBlock exercise) {
    ExerciseDataManager.removeExerciseBlock(exercise);
    this._exerciseList.remove(exercise);
    this._exerciseList.sort((w1,w2) => w1.name.compareTo(w2.name));
    notifyListeners();
  }

  void updateExerciseBlock(ExerciseBlock exercise, {String name}) {
    if (name != null && name.length > 0)
      exercise.name = name;
    ExerciseDataManager.updateExerciseBlock(exercise);
    this._exerciseList.sort((w1,w2) => w1.name.compareTo(w2.name));
    notifyListeners();
  }
}