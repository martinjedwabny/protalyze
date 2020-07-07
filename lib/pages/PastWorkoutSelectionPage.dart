import 'package:Protalyze/containers/DateHeaderItem.dart';
import 'package:Protalyze/containers/PastWorkoutListItem.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/WorkoutDisplayPage.dart';
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
    Widget body;
    if (this.pastWorkouts.isEmpty) {
      body = SingleMessageScaffold('No registered workouts added yet.');
    } else {
      body = ListView(children: createListItems());
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
              PastWorkout pastWorkout = PastWorkout(w, DateTime.now());
              addPastWorkout(pastWorkout);
            })
          );
        },
      );
  }

  addPastWorkout(PastWorkout wk) {
    PastWorkoutDataManager.addPastWorkout(wk);
    setState(() {
      this.pastWorkouts.add(wk);
    });
  }

  removePastWorkout(PastWorkout wk) {
    PastWorkoutDataManager.removePastWorkout(wk);
    setState(() {
      this.pastWorkouts.remove(wk);
    });
  }

  void openPastWorkoutEditDialog(PastWorkoutListItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PastWorkoutEditDialog('Edit workout name', item.pastWorkout.workout.name, (String text, DateTime selectedDate) {
          setState(() {
            item.pastWorkout.workout.name = text;
            item.pastWorkout.dateTime = selectedDate;
            PastWorkoutDataManager.updatePastWorkout(item.pastWorkout);
          });
        },
        item.pastWorkout.dateTime
        );
      },
    );
  }

  List<Widget> createListItems() {
    this.pastWorkouts.sort((a,b) {
      return 1 - a.dateTime.compareTo(b.dateTime);
    });
    List<Widget> ans = [];
    for (int i = 0; i < pastWorkouts.length; i++){
      DateTime date = pastWorkouts[i].dateTime;
      String dateF = "${date.day}-${date.month}-${date.year}";
      DateTime otherDate = i == 0 ? null : pastWorkouts[i-1].dateTime;
      String otherF = i == 0 ? null : "${otherDate.day}-${otherDate.month}-${otherDate.year}";
      if (dateF != otherF) {
        ans.add(DateHeaderItem(date));
      }
      PastWorkoutListItem item = PastWorkoutListItem(pastWorkouts[i]);
      ans.add(Card(
        child: ListTile(
        title: item.buildTitle(context),
        subtitle: item.buildSubtitle(context),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkoutDisplayPage(item.pastWorkout.workout, canEdit: false,)),
          );
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
      )
      );
    }
    return ans;
  }

}