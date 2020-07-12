import 'package:Protalyze/containers/ListItem.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:flutter/material.dart';

/// A ListItem that contains data to display a heading.
class ExerciseBlockListItem implements ListItem {
  final ExerciseBlock block;

  ExerciseBlockListItem(this.block);

  Widget buildTitle(BuildContext context) {
    return Text(
      block.exercise.name,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget buildSubtitle(BuildContext context) {
    List<Widget> children = [];
    children.add(Text('Duration: ' + block.performingTime.inSeconds.toString() + 's, ' + 'Rest: ' + block.restTime.inSeconds.toString() + 's '));
    if (block.sets != null && block.sets > 1)
      children.add(Text('Sets: ' + block.sets.toString()));
    if (block.weight != null)
      children.add(Text('Weight: ' + block.weight.toString()));
    if (block.minReps != null && block.maxReps != null)
      children.add(Text('Reps: ' + block.minReps.toString() + '-' + block.maxReps.toString()));
    if (block.minReps != null && block.maxReps == null)
      children.add(Text('Reps: ' + block.minReps.toString() + ' min'));
    if (block.minReps == null && block.maxReps != null)
      children.add(Text('Reps: ' + block.maxReps.toString() + ' max'));
    return Wrap(
      direction: Axis.vertical,
      children: children,
    );
  }

  Widget buildInputFields(BuildContext context) => null;
}