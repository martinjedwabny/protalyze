import 'package:Protalyze/common/container/ListItem.dart';
import 'package:Protalyze/common/utils/DurationFormatter.dart';
import 'package:flutter/material.dart';
import 'package:Protalyze/common/domain/GroupBlock.dart';
import 'package:Protalyze/common/domain/ExerciseBlock.dart';

/// A ListItem that contains data to display a heading.
abstract class BlockListItem extends ListItem {

  Widget buildTitle(BuildContext context) => null;

  Widget buildContent(BuildContext context) => null;
}

class GroupBlockListItem extends BlockListItem{
  final GroupBlock block;

  GroupBlockListItem(this.block);

  Widget buildTitle(BuildContext context) {
    return Text(
      block.sets == null || block.sets == 1 ? block.name : '${block.sets} x ${block.name}',
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildContent(BuildContext context) => null;
}

class ExerciseBlockListItem extends BlockListItem{
  final ExerciseBlock block;

  ExerciseBlockListItem(this.block);

  Widget buildTitle(BuildContext context) {
    return Text(
      block.sets == null || block.sets == 1 ? block.name : '${block.sets} x ${block.name}',
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildContent(BuildContext context) {
    List<Widget> children = [];
    children.add(Text('Duration: ' + DurationFormatter.formatWithLetters(block.performingTime) + ', Rest: ' + DurationFormatter.formatWithLetters(block.restTime)));
    if (block.weight != null)
      children.add(Text('Weight: ' + block.weight.toString()));
    if (block.minReps != null && block.maxReps != null)
      children.add(Text('Reps: ' + block.minReps.toString() + '-' + block.maxReps.toString()));
    if (block.minReps != null && block.maxReps == null)
      children.add(Text('Reps: ' + block.minReps.toString() + ' min'));
    if (block.minReps == null && block.maxReps != null)
      children.add(Text('Reps: ' + block.maxReps.toString() + ' max'));
    if (block.objectives.length > 0) {
      String t = 'Targets: ';
      for (int i = 0; i < block.objectives.length; i++) {
        t += block.objectives[i].toString();
        if (i < block.objectives.length - 1)
          t += ', ';
      }
      children.add(Text(t));
    }
    return Wrap(
      direction: Axis.vertical,
      children: children,
    );
  }
}