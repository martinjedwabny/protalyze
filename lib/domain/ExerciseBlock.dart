import 'dart:convert';

import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/Weight.dart';

class ExerciseBlock {
  // Necessary
  Exercise exercise;
  Duration performingTime;
  Duration restTime;
  // Optional
  Weight weight;
  int minReps;
  int maxReps;
  bool inputReps;
  bool inputDifficulty;
  // Constructors
  ExerciseBlock(
    this.exercise, 
    this.performingTime, 
    this.restTime, {
      this.weight, 
      this.minReps, 
      this.maxReps, 
      this.inputReps = true, 
      this.inputDifficulty = true});

   ExerciseBlock.copy(ExerciseBlock other) {
    this.exercise = other.exercise; 
    this.performingTime = other.performingTime;
    this.restTime = other.restTime;
    this.weight = other.weight;
    this.minReps = other.minReps;
    this.maxReps = other.maxReps;
    this.inputReps = other.inputReps;
    this.inputDifficulty = other.inputDifficulty;
  }

  ExerciseBlock.fromJson(Map<String, dynamic> json)
    : exercise = Exercise.fromJson(json['exercise']),
      performingTime = Duration(seconds: json['performingTime']),
      restTime = Duration(seconds: json['restTime']),
      weight = json['weight'] == null || json['weight'] == "null" ? null : Weight.fromJson(json['weight']),
      minReps = jsonDecode(json['minReps']),
      maxReps = jsonDecode(json['maxReps']),
      inputReps = jsonDecode(json['inputReps']),
      inputDifficulty = jsonDecode(json['inputDifficulty'])
    ;

  Map<String, dynamic> toJson() =>
    {
      'exercise' : exercise.toJson(),
      'performingTime' : performingTime.inSeconds,
      'restTime' : restTime.inSeconds,
      'weight' : weight == null ? null : weight.toJson(),
      'minReps' : jsonEncode(minReps),
      'maxReps' : jsonEncode(maxReps),
      'inputReps' : jsonEncode(inputReps),
      'inputDifficulty' : jsonEncode(inputDifficulty),
    };
}