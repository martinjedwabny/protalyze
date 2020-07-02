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
    return Text(
      block.performingTime.inSeconds.toString() + ' seconds',
      // style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget buildInputFields(BuildContext context) => null;
}