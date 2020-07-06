import 'dart:convert';

import 'package:Protalyze/domain/ExerciseBlock.dart';

class Workout {
  String id;
  String name;
  List<ExerciseBlock> exercises;

  Workout(this.name, this.exercises);
  Workout.copy(Workout other){
    this.name = other.name;
    this.exercises = other.exercises.map((e) => ExerciseBlock.copy(e)).toList();
  }

  Workout.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        exercises = (jsonDecode(json['exercises']) as List<dynamic>).map((e) => ExerciseBlock.fromJson(e)).toList();

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'name': name,
      'exercises': jsonEncode(exercises),
    };
}