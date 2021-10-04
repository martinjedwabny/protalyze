import 'package:protalyze/common/container/ListItem.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:flutter/material.dart';

/// A ListItem that contains data to display a heading.
class WorkoutListItem implements ListItem {
  final Workout workout;

  WorkoutListItem(this.workout);

  Widget buildTitle(BuildContext context) {
    return Text(
      workout.name,
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildContent(BuildContext context) => null;
}