import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/bloc/WorkoutNotifier.dart';
import 'package:Protalyze/widgets/DateHeaderListItemWidget.dart';
import 'package:Protalyze/containers/PastWorkoutListItem.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/WorkoutDisplayPage.dart';
import 'package:Protalyze/widgets/PastWorkoutEditDialog.dart';
import 'package:Protalyze/widgets/PastWorkoutListItemWidget.dart';
import 'package:Protalyze/widgets/SingleMessageAlertDialog.dart';
import 'package:Protalyze/widgets/SingleMessageConfirmationDialog.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:Protalyze/widgets/SinglePickerAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastWorkoutSelectionPage extends StatefulWidget {
  @override
  _PastWorkoutSelectionPageState createState() =>
      _PastWorkoutSelectionPageState();
}

class _PastWorkoutSelectionPageState extends State<PastWorkoutSelectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
        if (notifier.pastWorkouts.isEmpty)
          return SingleMessageScaffold('No registered workouts added yet.');
        return ListView(
          children: createListItems(notifier.pastWorkouts), 
          padding: EdgeInsets.only(bottom: 80.0));
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'PastWorkoutAdd',
        tooltip: 'Register workout',
        onPressed: () {
          addNewPastWorkout();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void addNewPastWorkout() {
    List<Workout> workouts = Provider.of<WorkoutNotifier>(context, listen: false).workouts;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (workouts.isEmpty)
            return SingleMessageAlertDialog(
                'Error', 'Please add a workout before registering them.');
          return SinglePickerAlertDialog<Workout>(
              'Register a workout',
              'Select an option:',
              Map.fromIterable(workouts, key: (w) => w.name, value: (w) => w),
              ((Workout w) {
            PastWorkout pastWorkout = PastWorkout(w, DateTime.now());
            addPastWorkout(pastWorkout);
          }));
        });
  }

  void addPastWorkout(PastWorkout wk) {
    Provider.of<PastWorkoutNotifier>(context, listen: false).addPastWorkout(wk);
  }

  void removePastWorkout(PastWorkout wk) {
    showDialog(
      context: context,
      builder: (_) {
        return SingleMessageConfirmationDialog("Please confirm", "Do you really want to delete this workout?", 
        (){Provider.of<PastWorkoutNotifier>(context, listen: false).removePastWorkout(wk);}, 
        (){});
      },
    );
  }

  void updatePastWorkout(PastWorkout wk, String text, DateTime date) {
    Provider.of<PastWorkoutNotifier>(context, listen: false).updatePastWorkout(wk, name: text, date: date);
  }

  void openPastWorkoutEditDialog(PastWorkoutListItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PastWorkoutEditDialog(
            'Edit workout name', item.pastWorkout.workout.name,
            (String text, DateTime selectedDate) {
          updatePastWorkout(item.pastWorkout, text, selectedDate);
        }, item.pastWorkout.dateTime);
      },
    );
  }

  void openPastWorkoutDisplayPage(PastWorkoutListItem item){
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => WorkoutDisplayPage(
          item.pastWorkout.workout,
          canEdit: false,
        )),
    );
  }

  List<Widget> createListItems(List<PastWorkout> pastW) {
    List<PastWorkout> orderedPastWorkouts = pastW.toList();
    orderedPastWorkouts.sort((a, b) => - a.dateTime.compareTo(b.dateTime));
    List<Widget> ans = [];
    for (int i = 0; i < orderedPastWorkouts.length; i++) {
      DateTime date = orderedPastWorkouts[i].dateTime;
      String dateF = "${date.day}-${date.month}-${date.year}";
      DateTime otherDate = i == 0 ? null : orderedPastWorkouts[i - 1].dateTime;
      String otherF = i == 0
          ? null
          : "${otherDate.day}-${otherDate.month}-${otherDate.year}";
      if (dateF != otherF) {
        ans.add(DateHeaderListItemWidget(date));
      }
      PastWorkoutListItem item = PastWorkoutListItem(orderedPastWorkouts[i]);
      ans.add(PastWorkoutListItemWidget(item, 
        (){ openPastWorkoutDisplayPage(item); }, 
        (){ openPastWorkoutEditDialog(item); }, 
        (){ removePastWorkout(item.pastWorkout); }));
    }
    return ans;
  }
}
