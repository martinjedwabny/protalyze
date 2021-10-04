import 'dart:convert';

import 'package:protalyze/common/domain/Block.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';

class GroupBlock extends Block {
  List<Block> subBlocks;
  
  GroupBlock(String name, int sets, this.subBlocks) : super(name, sets);

  GroupBlock.copy(GroupBlock other) : super(other.name, other.sets) {
    this.subBlocks = other.subBlocks.map((e) => e.copy()).toList();
  }

  GroupBlock copy(){
    return new GroupBlock.copy(this);
  }

  GroupBlock.fromJson(Map<String, dynamic> json)
    : super(
      json['name'], 
      json['sets'] == null ? 1 : json['sets']) {
      this.subBlocks = (jsonDecode(json['subBlocks']) as List<dynamic>).map((e) => 
        e['type'] == 'group' ? GroupBlock.fromJson(e) : ExerciseBlock.fromJson(e)).toList();
    }

  Map<String, dynamic> toJson() =>
    {
      'type': 'group',
      'name' : name,
      'sets' : sets == null ? 1 : sets,
      'subBlocks' : jsonEncode(subBlocks),
    };
}