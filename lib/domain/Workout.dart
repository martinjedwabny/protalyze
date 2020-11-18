import 'dart:convert';

import 'package:Protalyze/domain/Block.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/ExerciseObjective.dart';
import 'package:Protalyze/domain/GroupBlock.dart';

class Workout {
  String documentId;
  String name;
  List<Block> blocks;
  Set<ExerciseObjectiveType> objectives;

  Workout(String name, List<Block> blocks) {
    this.name = name;
    this.blocks = blocks;
    this.objectives = generateObjectives(this.blocks);
  }
  Workout.copy(Workout other){
    this.name = other.name;
    this.blocks = other.blocks.map((e) => e.copy()).toList();
    this.objectives = generateObjectives(other.blocks);
  }

  Workout.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        blocks = (jsonDecode(json['exercises']) as List<dynamic>).map((e) => 
          e['type'] == 'group' ? GroupBlock.fromJson(e) : ExerciseBlock.fromJson(e)).toList() {
    objectives = generateObjectives(this.blocks);
  }

  Map<String, dynamic> toJson() =>
    {
      'name': name,
      'exercises': jsonEncode(blocks),
    };

  Set<ExerciseObjectiveType> generateObjectives(List<Block> blocks) {
    Set<ExerciseObjectiveType> res = Set<ExerciseObjectiveType>();
    for (Block b in blocks)
      res.addAll(generateObjectivesFromBlock(b));
    return res;
  }

  Set<ExerciseObjectiveType> generateObjectivesFromBlock(Block block) {
    Set<ExerciseObjectiveType> res = Set<ExerciseObjectiveType>();
    if (block is ExerciseBlock)
      res.addAll(block.objectives.map((e) => e.type).toSet());
    else if (block is GroupBlock)
      for (Block subBlock in block.subBlocks)
        res.addAll(generateObjectivesFromBlock(subBlock));
    return res;
  }
}