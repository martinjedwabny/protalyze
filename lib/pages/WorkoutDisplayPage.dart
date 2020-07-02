import 'package:Protalyze/containers/ExerciseBlockListItem.dart';
import 'package:Protalyze/containers/WorkoutListItem.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:flutter/material.dart';

class WorkoutDisplayPage extends StatefulWidget {
  final Workout workout;
  WorkoutDisplayPage(this.workout);

  @override
  _WorkoutDisplayPageState createState() => _WorkoutDisplayPageState();
}

class _WorkoutDisplayPageState extends State<WorkoutDisplayPage> {
  @override
  Widget build(BuildContext context) {
      List<ExerciseBlock> exercises = widget.workout.exercises;
      List<ExerciseBlockListItem> items = exercises.map((e) => ExerciseBlockListItem(e)).toList();
      return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
            ),
          );
        },
      )
    );
  }
}