import 'package:Protalyze/domain/ExerciseBlock.dart';

class Workout {
  String name;
  List<ExerciseBlock> exercises;
  Workout(this.name, this.exercises);
  Workout.copy(Workout other){
    this.name = other.name;
    this.exercises = other.exercises.map((e) => ExerciseBlock.copy(e)).toList();
  }
}