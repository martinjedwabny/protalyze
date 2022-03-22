import 'package:protalyze/common/container/ListItem.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:flutter/material.dart';

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

  Widget buildContent(BuildContext context) => null;
}
