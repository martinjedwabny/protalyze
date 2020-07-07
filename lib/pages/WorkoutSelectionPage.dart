import 'package:Protalyze/containers/WorkoutListItem.dart';
import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/WorkoutDisplayPage.dart';
import 'package:Protalyze/persistance/Authentication.dart';
import 'package:Protalyze/persistance/WorkoutDataManager.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:Protalyze/widgets/TextInputAlertDialog.dart';
import 'package:flutter/material.dart';

class WorkoutSelectionPage extends StatefulWidget {
  final BaseAuth auth;
  WorkoutSelectionPage({this.auth});
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> with AutomaticKeepAliveClientMixin {
  List<Workout> workouts = [];
  List<WorkoutListItem> items = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WorkoutDataManager.getSavedWorkouts().then((workouts) {
      setState(() {
        this.workouts = workouts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            trailing: Wrap(
                  spacing: 4, // space between two icons
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.add), tooltip: 'Duplicate', onPressed: () {
                      duplicateWorkout(item.workout);
                    },),
                    IconButton(icon: Icon(Icons.edit), tooltip: 'Edit', onPressed: () {
                      openWorkoutNameEditDialog(item);
                    },),
                    IconButton(icon: Icon(Icons.delete_outline), tooltip: 'Remove', onPressed: () {
                      removeWorkout(item.workout);
                    }),
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
        heroTag: 'WorkoutAdd',
        tooltip: 'Add workout',
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
    WorkoutDataManager.addWorkout(wk).then((value) {});
    addWorkout(wk);
  }

  addWorkout(Workout wk) {
    setState(() {
      this.items.add(WorkoutListItem(wk));
    });
  }
  
  duplicateWorkout(Workout wk) {
    Workout wkCopy = Workout.copy(wk);
    WorkoutDataManager.addWorkout(wkCopy);
    addWorkout(wkCopy);
  }

  removeWorkout(Workout wk) {
    WorkoutDataManager.removeWorkout(wk);
    setState(() {
      this.workouts.remove(wk);
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
    WorkoutDataManager.updateWorkout(item.workout);
  }
}

