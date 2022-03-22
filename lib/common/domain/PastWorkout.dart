import 'package:protalyze/common/domain/Workout.dart';

class PastWorkout {
  final Workout workout;
  DateTime dateTime;
  String documentId;
  String notes;
  PastWorkout(this.workout, this.dateTime, this.notes);

  PastWorkout.fromJson(Map<String, dynamic> json)
      : workout = Workout.fromJson(json['workout']),
        dateTime = DateTime.tryParse(json['dateTime']),
        notes = json['notes'];

  Map<String, dynamic> toJson() => {
        'workout': workout.toJson(),
        'dateTime': dateTime.toIso8601String(),
        'notes': notes
      };
}
