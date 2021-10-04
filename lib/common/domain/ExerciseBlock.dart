import 'dart:convert';
import 'package:protalize/common/domain/ExerciseObjective.dart';
import 'package:protalize/common/domain/Weight.dart';
import 'Block.dart';

class ExerciseBlock extends Block {
  // Necessary
  Duration performingTime;
  Duration restTime;
  // Optional
  Weight weight;
  int minReps;
  int maxReps;
  bool inputReps;
  bool inputDifficulty;
  List<ExerciseObjective> objectives;
  // Constructors
  ExerciseBlock(
    String name,  
    int sets,
    this.performingTime, 
    this.restTime, {
      this.weight, 
      this.minReps, 
      this.maxReps,
      this.inputReps = true, 
      this.inputDifficulty = true,
      this.objectives}) : super(name, sets) {
        if (objectives == null)
          objectives = [];
      }

   ExerciseBlock.copy(ExerciseBlock other) : super(other.name, other.sets) {
    this.performingTime = other.performingTime;
    this.restTime = other.restTime;
    this.weight = other.weight;
    this.minReps = other.minReps;
    this.maxReps = other.maxReps;
    this.inputReps = other.inputReps;
    this.inputDifficulty = other.inputDifficulty;
    this.objectives = other.objectives;
    if (objectives == null)
      objectives = [];
  }

  ExerciseBlock copy(){
    return new ExerciseBlock.copy(this);
  }

  ExerciseBlock.fromJson(Map<String, dynamic> json)
    : super(
      json['name'], 
      json['sets'] == null ? 1 : json['sets']) {
      this.performingTime = Duration(seconds: json['performingTime']);
      this.restTime = Duration(seconds: json['restTime']);
      this.weight = json['weight'] == null || json['weight'] == "null" ? null : Weight.fromJson(json['weight']);
      this.minReps = jsonDecode(json['minReps']);
      this.maxReps = jsonDecode(json['maxReps']);
      this.inputReps = jsonDecode(json['inputReps']);
      this.inputDifficulty = jsonDecode(json['inputDifficulty']);
      this.objectives = json['objectives'] == null ? [] : (jsonDecode(json['objectives']) as List<dynamic>).map((e) => 
        ExerciseObjective.fromString(e)).toList();
    }

  Map<String, dynamic> toJson() =>
    {
      'type': 'exercise',
      'name' : name,
      'performingTime' : performingTime.inSeconds,
      'restTime' : restTime.inSeconds,
      'weight' : weight == null ? null : weight.toJson(),
      'minReps' : jsonEncode(minReps),
      'maxReps' : jsonEncode(maxReps),
      'sets' : sets == null ? 1 : sets,
      'inputReps' : jsonEncode(inputReps),
      'inputDifficulty' : jsonEncode(inputDifficulty),
      'objectives' : objectives == null ? null : jsonEncode(objectives.map((e) => e.toString()).toList()),
    };

  String toString(){
    String ans = this.name;
    if (this.weight != null) ans += ', ' + this.weight.toString();
    if (this.minReps != null && this.maxReps != null)
      ans += ', ' +
          this.minReps.toString() +
          '-' +
          this.maxReps.toString() +
          ' reps';
    if (this.minReps != null && this.maxReps == null)
      ans += ', ' + this.minReps.toString() + ' min reps';
    if (this.minReps == null && this.maxReps != null)
      ans += ', ' + this.maxReps.toString() + ' max reps';
    return ans;
  }
}