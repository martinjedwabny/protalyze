import 'package:protalyze/common/container/ListItem.dart';
import 'package:protalyze/common/domain/PastWorkout.dart';
import 'package:flutter/material.dart';

/// A ListItem that contains data to display a heading.
class PastWorkoutListItem implements ListItem {
  final PastWorkout pastWorkout;

  PastWorkoutListItem(this.pastWorkout);

  Widget buildTitle(BuildContext context) {
    return Text(
      pastWorkout.workout.name,
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildContent(BuildContext context) => null;
}