import 'package:Protalyze/containers/WorkoutListItem.dart';
import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/WorkoutDisplayPage.dart';
import 'package:flutter/material.dart';

class WorkoutSelectionPage extends StatefulWidget {
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  List<ExerciseBlock> exercises;
  List<WorkoutListItem> items;

  @override
  Widget build(BuildContext context) {
    if (this.items == null) {
      this.exercises = [
        ExerciseBlock(Exercise("Bench press"), Duration(seconds: 30), Duration(seconds: 90)),
        ExerciseBlock(Exercise("Bench press"), Duration(seconds: 30), Duration(seconds: 90)),
        ExerciseBlock(Exercise("Pullups"), Duration(seconds: 30), Duration(seconds: 90)),
        ExerciseBlock(Exercise("Pullups"), Duration(seconds: 30), Duration(seconds: 90)),
      ];
      this.items = [
        WorkoutListItem(Workout('Workout 1', exercises)),
        WorkoutListItem(Workout('Workout 2', exercises)),
        WorkoutListItem(Workout('Workout 3', exercises))];
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          WorkoutListItem item = items[index];
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
            trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () {
                      duplicateWorkout(item.workout);
                    },), // icon-1
                    IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: () {
                      removeWorkout(item.workout);
                    }),// icon-2
                  ],
                ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          addNewWorkout(); 
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }


  addNewWorkout(){
    Workout wk = Workout('New workout', []);
    addWorkout(wk);
  }

  addWorkout(Workout wk) {
    setState(() {
      this.items.add(WorkoutListItem(wk));
    });
  }
  
  duplicateWorkout(Workout wk) {
    addWorkout(Workout.copy(wk));
  }

  removeWorkout(Workout wk) {
    setState(() {
      this.items.removeWhere((element) => element.workout == wk);
    });
  }
}

