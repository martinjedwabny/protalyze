import 'package:Protalyze/containers/PastWorkoutListItem.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/persistance/Authentication.dart';
import 'package:Protalyze/persistance/PastWorkoutDataManager.dart';
import 'package:Protalyze/persistance/WorkoutDataManager.dart';
import 'package:Protalyze/widgets/PastWorkoutEditDialog.dart';
import 'package:Protalyze/widgets/SingleMessageAlertDialog.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:Protalyze/widgets/SinglePickerAlertDialog.dart';
import 'package:flutter/material.dart';

class PastWorkoutSelectionPage extends StatefulWidget {
  final BaseAuth auth;
  PastWorkoutSelectionPage({this.auth});
  @override
  _PastWorkoutSelectionPageState createState() => _PastWorkoutSelectionPageState();
}

class _PastWorkoutSelectionPageState extends State<PastWorkoutSelectionPage> with AutomaticKeepAliveClientMixin {
  List<Workout> workouts = [];
  List<PastWorkout> pastWorkouts = [];
  List<PastWorkoutListItem> items = [];

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    PastWorkoutDataManager.getSavedPastWorkouts().then((pastWorkouts) {
      WorkoutDataManager.getSavedWorkouts().then((workouts) {
        setState(() {
          this.pastWorkouts = pastWorkouts;
          this.workouts = workouts;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (this.items == null || this.items.isEmpty) {
      this.items = this.pastWorkouts.map((e) => PastWorkoutListItem(e)).toList();
    }
    Widget body;
    if (this.items.isEmpty) {
      body = SingleMessageScaffold('No registered workouts added yet.');
    } else {
      body = ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          PastWorkoutListItem item = items[index];
          return Card(
            child: ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => PastWorkoutDisplayPage(item.workout)),
              // );
            },
            trailing: Wrap(
                  spacing: 4, // space between two icons
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.edit), tooltip: 'Edit', onPressed: () {
                      openPastWorkoutEditDialog(item);
                    },),
                    IconButton(icon: Icon(Icons.delete_outline), tooltip: 'Remove', onPressed: () {
                      removePastWorkout(item.pastWorkout);
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
        heroTag: 'PastWorkoutAdd',
        tooltip: 'Register workout',
        onPressed: () { 
          addNewPastWorkout(); 
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }


  addNewPastWorkout(){
    if (this.workouts.isEmpty)
      showDialog(context: context,
      builder: (BuildContext context) {
        return SingleMessageAlertDialog('Error', 'Please add a workout before registering them.');
      });
    else
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SinglePickerAlertDialog<Workout>(
          'Register a workout', 
          'Select an option:', 
          Map.fromIterable(this.workouts, key: (w) => w.name, value: (w) => w), 
          ((Workout w) {
            print(w.toJson());
          })
        );
      },
    );
    // PastWorkout wk =  PastWorkout('New workout', []);
    // addPastWorkout(wk);
  }

  addPastWorkout(PastWorkout wk) {
    setState(() {
      this.items.add(PastWorkoutListItem(wk));
    });
  }

  removePastWorkout(PastWorkout wk) {
    PastWorkoutDataManager.removePastWorkout(wk);
    setState(() {
      this.items.removeWhere((element) => element.pastWorkout == wk);
    });
  }

  void openPastWorkoutEditDialog(PastWorkoutListItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PastWorkoutEditDialog('Edit workout name', item.pastWorkout.workout.name, (String text, DateTime selectedDate) {
          // setState(() {
          //   item.pastWorkout.workout.name = text;
          //   PastWorkoutDataManager.updatePastWorkout(item.pastWorkout);
          // });
        },
        item.pastWorkout.dateTime
        );
      },
    );
  }
}

