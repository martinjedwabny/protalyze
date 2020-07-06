import 'package:Protalyze/containers/WorkoutListItem.dart';
import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/WorkoutDisplayPage.dart';
import 'package:Protalyze/persistance/Authentication.dart';
import 'package:Protalyze/persistance/UserDataManager.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:Protalyze/widgets/TextInputAlertDialog.dart';
import 'package:flutter/material.dart';

class WorkoutSelectionPage extends StatefulWidget {
  final BaseAuth auth;
  WorkoutSelectionPage({this.auth});
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  List<Workout> workouts = [];
  List<WorkoutListItem> items = [];

  @override
  void initState() {
    super.initState();
    UserDataManager.getSavedWorkouts().then((workouts) {
      setState(() {
        this.workouts = workouts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.items == null || this.items.isEmpty) {
      this.items = this.workouts.map((e) => WorkoutListItem(e)).toList();
    }
    Widget body;
    if (this.items.isEmpty) {
      body = SingleMessageScaffold('No workouts added yet.');
    } else {
      body = ListView.builder(
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
            onLongPress: () {
              openWorkoutNameEditDialog(item);
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
      );
    }
    return Scaffold(
      body: body,
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
    wk.exercises = [
        ExerciseBlock(Exercise("New exercise"), Duration(seconds: 30), Duration(seconds: 90)),
      ];
    UserDataManager.addNewWorkout(wk).then((value) {});
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

  void openWorkoutNameEditDialog(WorkoutListItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TextInputAlertDialog('Edit workout name', (String text) {
          setState(() {
            updateWorkoutName(item, text);
          });
        },
        initialValue: item.workout.name
        );
      },
    );
  }

  void updateWorkoutName(WorkoutListItem item, String name) {
    item.workout.name = name;
  }
}

