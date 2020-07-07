import 'package:Protalyze/containers/ExerciseBlockListItem.dart';
import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/ExerciseEditPage.dart';
import 'package:Protalyze/persistance/WorkoutDataManager.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:flutter/material.dart';

class WorkoutDisplayPage extends StatefulWidget {
  final Workout workout;
  final List<ExerciseBlockListItem> items;
  
  WorkoutDisplayPage(this.workout) :
    this.items = workout.exercises.map((e) => ExerciseBlockListItem(e)).toList();

  @override
  _WorkoutDisplayPageState createState() => _WorkoutDisplayPageState();
}

class _WorkoutDisplayPageState extends State<WorkoutDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: widget.items.isEmpty ? 
        SingleMessageScaffold('No exercises added yet.') :
        ReorderableListView(
          children: widget.items.map((item) => Card(
              key: ValueKey(item),
              child: ListTile(
                title: item.buildTitle(context),
                subtitle: item.buildSubtitle(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExerciseEditPage(item.block, updateExercise)),
                  ).then((value) {
                    setState(() {
                    });
                  });
                },
                trailing: Wrap(
                  spacing: 4, // space between two icons
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.add), tooltip: 'Duplicate', onPressed: () {
                      duplicateExercise(item.block);
                    },), // icon-1
                    IconButton(icon: Icon(Icons.delete_outline), tooltip: 'Remove', onPressed: () {
                      removeExercise(item.block);
                    }),// icon-2
                  ],
                ),
              ),
            )).toList(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                reorderItems(oldIndex, newIndex);
              });
            },
          ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'ExerciseAdd',
        tooltip: 'Add exercise',
        onPressed: () { 
          addNewExercise(); 
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (newIndex != oldIndex) {
      if (oldIndex < newIndex)
        newIndex -= 1;
      ExerciseBlockListItem item = widget.items.removeAt(oldIndex);
      widget.items.insert(newIndex, item);
      List<ExerciseBlock> exercises = widget.workout.exercises;
      ExerciseBlock block = exercises.removeAt(oldIndex);
      exercises.insert(newIndex, block);
      updateExercise(block);
    }
  }

  addNewExercise(){
    ExerciseBlock block = ExerciseBlock(Exercise('New exercise'), Duration(seconds: 30), Duration(seconds: 90));
    addExercise(block);
  }
  
  duplicateExercise(ExerciseBlock block) {
    ExerciseBlock blockCopy = ExerciseBlock(Exercise(block.exercise.name), Duration(seconds: block.performingTime.inSeconds), Duration(seconds: block.restTime.inSeconds), weight: block.weight, minReps: block.minReps, maxReps: block.maxReps, inputReps: block.inputReps, inputDifficulty: block.inputDifficulty);
    addExercise(blockCopy);
  }

  addExercise(ExerciseBlock block) {
    setState(() {
      widget.workout.exercises.add(block);
      widget.items.add(ExerciseBlockListItem(block));
      WorkoutDataManager.updateWorkout(widget.workout);
    });
  }

  removeExercise(ExerciseBlock block) {
    setState(() {
      widget.workout.exercises.remove(block);
      widget.items.removeWhere((element) => element.block == block);
      WorkoutDataManager.updateWorkout(widget.workout);
    });
  }
  

  void updateExercise(ExerciseBlock block) {
    WorkoutDataManager.updateWorkout(widget.workout);
    setState(() {});
  }
}