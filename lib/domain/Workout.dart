import 'dart:convert';

import 'package:Protalyze/domain/Block.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/GroupBlock.dart';

class Workout {
  String documentId;
  String name;
  List<Block> blocks;

  Workout(this.name, this.blocks);
  Workout.copy(Workout other){
    this.name = other.name;
    this.blocks = other.blocks.map((e) => e.copy()).toList();
  }

  Workout.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        blocks = (jsonDecode(json['exercises']) as List<dynamic>).map((e) => 
          e['type'] == 'group' ? GroupBlock.fromJson(e) : ExerciseBlock.fromJson(e)).toList();

  Map<String, dynamic> toJson() =>
    {
      'name': name,
      'exercises': jsonEncode(blocks),
    };
}