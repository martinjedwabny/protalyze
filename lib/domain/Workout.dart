import 'dart:convert';

import 'package:Protalyze/domain/Block.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/ExerciseObjective.dart';
import 'package:Protalyze/domain/GroupBlock.dart';

class Workout {
  String documentId;
  String name;
  List<Block> blocks;

  Workout(String name, List<Block> blocks) {
    this.name = name;
    this.blocks = blocks;
  }

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

  Map<ExerciseObjective, int> get objectiveCount {
    return generateObjectives(this.blocks);
  }

  Map<ExerciseObjective, int> generateObjectives(List<Block> blocks) {
    Map<ExerciseObjective, int> res = Map<ExerciseObjective, int>();
    for (String t in ExerciseObjective.names)
      res[ExerciseObjective(t)] = 0;
    for (Block block in blocks)
      if (block is ExerciseBlock)
        for (var o in block.objectives)
          res[o] += block.sets == null ? 1 : block.sets;
      else if (block is GroupBlock)
        for (ExerciseBlock subBlock in block.subBlocks)
          for (var o in subBlock.objectives)
            res[o] += (block.sets == null ? 1 : block.sets) * (subBlock.sets == null ? 1 : subBlock.sets);
    return res;
  }
}