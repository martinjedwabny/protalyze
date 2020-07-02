import 'package:Protalyze/containers/ListItem.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:flutter/material.dart';

/// A ListItem that contains data to display a heading.
class WorkoutListItem implements ListItem {
  final Workout workout;

  WorkoutListItem(this.workout);

  Widget buildTitle(BuildContext context) {
    return Text(
      workout.name,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;

  Widget buildInputFields(BuildContext context) => null;
}