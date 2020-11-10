import 'package:Protalyze/containers/BlockListItem.dart';
import 'package:Protalyze/containers/ExerciseBlockListItem.dart';
import 'package:Protalyze/domain/Block.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/GroupBlock.dart';
import 'package:Protalyze/domain/Workout.dart';

class WorkoutToBlockListItemAdapter{
  static List<BlockListItem> getBlockListItems(Workout workout) {
    List<BlockListItem> ans = [];
    for (Block block in workout.blocks) {
      ans += getBlockListItemsFromBlock(block);
    }
    return ans;
  }

  static List<BlockListItem> getBlockListItemsFromBlock(Block block) {
    return block is GroupBlock ? getBlockListItemsFromGroupBlock(block) : getBlockListItemsFromExerciseBlock(block);
  }

  static List<BlockListItem> getBlockListItemsFromGroupBlock(GroupBlock block) {
    List<BlockListItem> ans = [];
    return ans;
  }

  static List<BlockListItem> getBlockListItemsFromExerciseBlock(ExerciseBlock block) {
    return [new ExerciseBlockListItem(block)];
  }
}