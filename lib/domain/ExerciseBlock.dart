import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/Weight.dart';

class ExerciseBlock {
  // Necessary
  final Exercise exercise;
  final Duration performingTime;
  final Duration restTime;
  // Optional
  final Weight weight;
  final int minReps;
  final int maxReps;
  final bool inputReps;
  final bool inputDifficulty;
  // Constructors
  ExerciseBlock(this.exercise, this.performingTime, this.restTime, [this.weight, this.minReps, this.maxReps, this.inputReps, this.inputDifficulty]);
}