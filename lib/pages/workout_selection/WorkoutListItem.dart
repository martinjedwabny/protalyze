import 'package:protalyze/common/container/ListItem.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:flutter/material.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';
import 'package:protalyze/pages/countdown/CountdownElement.dart';
import 'package:protalyze/pages/countdown/WorkoutToCountdownAdapter.dart';

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

  Widget buildContent(BuildContext context) {
    List<CountdownElement> countdownElements =
        WorkoutToCountdownAdapter.getCountdownElements(workout);
    Duration totalTime = countdownElements.fold(Duration.zero,
        (previousValue, element) => previousValue + element.totalTime);
    return Text(
      'Duration: ' + DurationFormatter.formatWithLetters(totalTime),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
