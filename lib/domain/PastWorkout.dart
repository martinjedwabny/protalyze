import 'package:Protalyze/domain/Workout.dart';

class PastWorkout {
  final Workout workout;
  final DateTime dateTime;
  String documentId;
  PastWorkout(this.workout, this.dateTime);

  PastWorkout.fromJson(Map<String, dynamic> json)
      : workout = Workout.fromJson(json['workout']),
        dateTime = DateTime.tryParse(json['dateTime']);

  Map<String, dynamic> toJson() =>
    {
      'workout': workout,
      'dateTime': dateTime.toIso8601String(),
    };
}