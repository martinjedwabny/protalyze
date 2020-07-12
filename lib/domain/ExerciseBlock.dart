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
  int sets;
  // Constructors
  ExerciseBlock(
    this.exercise, 
    this.performingTime, 
    this.restTime, {
      this.weight, 
      this.minReps, 
      this.maxReps, 
      this.sets,
      this.inputReps = true, 
      this.inputDifficulty = true});

   ExerciseBlock.copy(ExerciseBlock other) {
    this.exercise = other.exercise; 
    this.performingTime = other.performingTime;
    this.restTime = other.restTime;
    this.weight = other.weight;
    this.minReps = other.minReps;
    this.maxReps = other.maxReps;
    this.sets = other.sets;
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
      sets = json['sets'] == null ? 1 : jsonDecode(json['sets']),
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
      'sets' : sets == null ? 1 : jsonEncode(sets),
      'inputReps' : jsonEncode(inputReps),
      'inputDifficulty' : jsonEncode(inputDifficulty),
    };
}