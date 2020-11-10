import 'package:Protalyze/domain/Block.dart';
import 'package:Protalyze/domain/CountdownElement.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/GroupBlock.dart';
import 'package:Protalyze/domain/Workout.dart';

class WorkoutToCountdownAdapter{
  static List<CountdownElement> getCountdownElements(Workout workout) {
    List<CountdownElement> ans = [];
    for (Block block in workout.blocks) {
      ans += getCountdownElementsFromBlock(block);
    }
    return ans;
  }

  static List<CountdownElement> getCountdownElementsFromBlock(Block block) {
    return block is GroupBlock ? getCountdownElementsFromGroupBlock(block) : getCountdownElementsFromExerciseBlock(block);
  }

  static List<CountdownElement> getCountdownElementsFromGroupBlock(GroupBlock block) {
    List<CountdownElement> ans = [];
    for (Block block in block.subBlocks) {
      int sets = block.sets == null ? 1 : block.sets;
      for (int i = 0; i < sets; i++){
        ans += getCountdownElementsFromBlock(block);
      }
    }
    return ans;
  }

  static List<CountdownElement> getCountdownElementsFromExerciseBlock(ExerciseBlock block) {
    List<CountdownElement> ans = [];
    int sets = block.sets == null ? 1 : block.sets;
    for (int i = 0; i < sets; i++){
      if (block.performingTime != null && block.performingTime.inSeconds > 0) {
        ans.add(new CountdownElement(block.toString(), block.performingTime));
      }
      if (block.restTime != null && block.restTime.inSeconds > 0) {
        ans.add(new CountdownElement('Rest', block.restTime));
      }
    }
    return ans;
  }
}