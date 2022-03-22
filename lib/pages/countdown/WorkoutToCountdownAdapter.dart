import 'package:protalyze/common/domain/Block.dart';
import 'package:protalyze/pages/countdown/CountdownElement.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:protalyze/common/domain/GroupBlock.dart';
import 'package:protalyze/common/domain/Workout.dart';

class WorkoutToCountdownAdapter {
  static List<CountdownElement> getCountdownElements(Workout workout) {
    List<CountdownElement> ans = [];
    for (Block block in workout.blocks) {
      ans += getCountdownElementsFromBlock(block);
    }
    return ans;
  }

  static List<CountdownElement> getCountdownElementsFromBlock(Block block) {
    return block is GroupBlock
        ? getCountdownElementsFromGroupBlock(block)
        : getCountdownElementsFromExerciseBlock(block);
  }

  static List<CountdownElement> getCountdownElementsFromGroupBlock(
      GroupBlock block) {
    List<CountdownElement> ans = [];
    int sets = block.sets == null ? 1 : block.sets;
    for (int i = 0; i < sets; i++)
      for (Block block in block.subBlocks)
        ans += getCountdownElementsFromBlock(block);
    return ans;
  }

  static List<CountdownElement> getCountdownElementsFromExerciseBlock(
      ExerciseBlock block) {
    List<CountdownElement> ans = [];
    int sets = block.sets == null ? 1 : block.sets;
    for (int i = 0; i < sets; i++) {
      if (block.performingTime != null && block.performingTime.inSeconds > 0) {
        ans.add(new CountdownElement(
            block.toString(), block.performingTime, block.gifUrl));
      }
      if (block.restTime != null && block.restTime.inSeconds > 0) {
        ans.add(new CountdownElement('Rest', block.restTime, ''));
      }
    }
    return ans;
  }
}
