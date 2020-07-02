import 'package:Protalyze/containers/WorkoutListItem.dart';
import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/WorkoutDisplayPage.dart';
import 'package:flutter/material.dart';

class WorkoutSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ExerciseBlock> exercises = [
      ExerciseBlock(Exercise("Bench press"), Duration(seconds: 30), Duration(seconds: 90)),
      ExerciseBlock(Exercise("Bench press"), Duration(seconds: 30), Duration(seconds: 90)),
      ExerciseBlock(Exercise("Pullups"), Duration(seconds: 30), Duration(seconds: 90)),
      ExerciseBlock(Exercise("Pullups"), Duration(seconds: 30), Duration(seconds: 90)),
    ];
    List<WorkoutListItem> items = [
      WorkoutListItem(Workout('Workout 1', exercises)),
      WorkoutListItem(Workout('Workout 2', exercises)),
      WorkoutListItem(Workout('Workout 3', exercises))];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
          title: item.buildTitle(context),
          subtitle: item.buildSubtitle(context),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkoutDisplayPage(item.workout)),
            );
          },
          ),
        );
      },
    );
  }
}

