import 'package:Protalyze/containers/ListItem.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:flutter/material.dart';

/// A ListItem that contains data to display a heading.
class PastWorkoutListItem implements ListItem {
  final PastWorkout pastWorkout;

  PastWorkoutListItem(this.pastWorkout);

  Widget buildTitle(BuildContext context) {
    return Text(
      pastWorkout.workout.name,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;

  Widget buildInputFields(BuildContext context) => null;
}