import 'dart:convert';

import 'package:protalyze/common/domain/Block.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:protalyze/common/domain/GroupBlock.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';

class WorkoutFormatter {
  static String formatWorkoutToJson(Workout workout) {
    return jsonEncode(workout.toJson());
  }

  static String formatWorkoutToString(Workout workout) {
    StringBuffer buf = StringBuffer();
    buf.writeln(workout.name + ':');
    workout.blocks.forEach((block) {
      buf.writeln(formatBlockToString(block, 0));
    });
    print(buf.toString());
    return buf.toString();
  }

  static String formatBlockToString(Block block, int depth) {
    StringBuffer buf = StringBuffer();
    String spaces = "  ";
    if (block is GroupBlock) {
      buf.writeln(spaces * depth + block.sets.toString() + 'x (');
      block.subBlocks.forEach((subBlock) {
        buf.writeln(formatBlockToString(subBlock, depth + 1));
      });
      buf.write(spaces * depth + ')');
    } else if (block is ExerciseBlock) {
      buf.write(spaces * depth +
          block.sets.toString() +
          'x (' +
          block.name +
          ': ' +
          DurationFormatter.formatWithLetters(block.performingTime) +
          ' work, ' +
          DurationFormatter.formatWithLetters(block.restTime) +
          ' rest' +
          ')');
    }
    return buf.toString();
  }
}
