import 'package:protalyze/common/container/ListItem.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:flutter/material.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';

/// A ListItem that contains data to display a heading.
class ExerciseListItem implements ListItem {
  final ExerciseBlock exercise;

  ExerciseListItem(this.exercise);

  Widget buildTitle(BuildContext context) {
    return Text(
      exercise.name,
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildContent(BuildContext context) {
    List<Widget> children = [];
    children.add(Text('Duration: ' +
        DurationFormatter.formatWithLetters(exercise.performingTime) +
        ', Rest: ' +
        DurationFormatter.formatWithLetters(exercise.restTime)));
    if (exercise.objectives.length > 0) {
      String t = 'Targets: ';
      for (int i = 0; i < exercise.objectives.length; i++) {
        t += exercise.objectives[i].toString();
        if (i < exercise.objectives.length - 1) t += ', ';
      }
      children.add(Text(
        t,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));
    }
    return Wrap(
      direction: Axis.vertical,
      children: children,
    );
  }
}
