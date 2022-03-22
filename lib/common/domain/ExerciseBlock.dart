import 'dart:convert';
import 'package:protalyze/common/domain/ExerciseObjective.dart';
import 'Block.dart';

class ExerciseBlock extends Block {
  // Necessary
  String documentId;
  Duration performingTime;
  Duration restTime;
  List<ExerciseObjective> objectives;
  String gifUrl;
  // Constructors
  ExerciseBlock(String name, int sets, this.performingTime, this.restTime,
      {this.objectives, this.gifUrl})
      : super(name, sets) {
    if (objectives == null) objectives = [];
  }

  ExerciseBlock.copy(ExerciseBlock other) : super(other.name, other.sets) {
    this.performingTime = other.performingTime;
    this.restTime = other.restTime;
    this.objectives = other.objectives;
    if (objectives == null) objectives = [];
    this.gifUrl = other.gifUrl;
  }

  ExerciseBlock copy() {
    return new ExerciseBlock.copy(this);
  }

  ExerciseBlock.fromJson(Map<String, dynamic> json)
      : super(json['name'], json['sets'] == null ? 1 : json['sets']) {
    this.performingTime = Duration(seconds: json['performingTime']);
    this.restTime = Duration(seconds: json['restTime']);
    this.objectives = json['objectives'] == null
        ? []
        : (jsonDecode(json['objectives']) as List<dynamic>)
            .map((e) => ExerciseObjective.fromString(e))
            .toList();
    this.gifUrl = json['gifUrl'];
  }

  Map<String, dynamic> toJson() => {
        'type': 'exercise',
        'name': name,
        'sets': sets == null ? 1 : sets,
        'performingTime': performingTime.inSeconds,
        'restTime': restTime.inSeconds,
        'objectives': objectives == null
            ? null
            : jsonEncode(objectives.map((e) => e.toString()).toList()),
        'gifUrl': gifUrl,
      };

  String toString() {
    String ans = this.name;
    return ans;
  }
}
