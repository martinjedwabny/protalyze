import 'package:Protalyze/containers/ListItem.dart';
import 'package:flutter/material.dart';
import 'package:Protalyze/domain/GroupBlock.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';

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
    children.add(Text('Duration: ' + block.performingTime.inSeconds.toString() + 's, ' + 'Rest: ' + block.restTime.inSeconds.toString() + 's '));
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
}