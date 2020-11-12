import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/bloc/WorkoutNotifier.dart';
import 'package:Protalyze/containers/WorkoutListItem.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/CountdownPage.dart';
import 'package:Protalyze/pages/WorkoutDisplayPage.dart';
import 'package:Protalyze/widgets/SingleMessageAlertDialog.dart';
import 'package:Protalyze/widgets/SingleMessageConfirmationDialog.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:Protalyze/widgets/SinglePickerAlertDialog.dart';
import 'package:Protalyze/widgets/TextInputAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutSelectionPage extends StatefulWidget {
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget playButton = FloatingActionButton(
      heroTag: 'WorkoutPlay',
      tooltip: 'Play',
      onPressed: () {
        playWorkout();
      },
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
      )
    );
    Widget addButton = FloatingActionButton(
      heroTag: 'WorkoutAdd',
      tooltip: 'Add workout',
      onPressed: () {
        addNewWorkout();
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      )
    );
    return Scaffold(
      body: Consumer<WorkoutNotifier>(builder: (context, notifier, child) {
        if (notifier.workouts.isEmpty)
          return SingleMessageScaffold('No workouts added yet.');
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 80.0),
          itemCount: notifier.workouts.length,
          itemBuilder: (context, index) {
            WorkoutListItem item = WorkoutListItem(notifier.workouts[index]);
            return Card(
              child: ListTile(
                title: item.buildTitle(context),
                subtitle: item.buildContent(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<PastWorkoutNotifier>.value(
                        value: Provider.of<PastWorkoutNotifier>(this.context), 
                        child: ChangeNotifierProvider<WorkoutNotifier>.value(
                          value: Provider.of<WorkoutNotifier>(this.context), 
                          child: WorkoutDisplayPage(item.workout)
                        ),
                      ),
                    )
                  );
                },
                trailing: Wrap(
                  spacing: 0.0, // space between two icons
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add),
                      tooltip: 'Duplicate',
                      onPressed: () {
                        duplicateWorkout(item.workout);
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.delete_outline),
                        tooltip: 'Remove',
                        onPressed: () {
                          removeWorkout(item.workout);
                        }),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Wrap(spacing: 10.0, children: [ playButton, addButton, ],
      ),
    );
  }

  void playWorkout(){
    List<Workout> workouts = Provider.of<WorkoutNotifier>(context, listen: false).workouts;
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        if (workouts.isEmpty)
          return SingleMessageAlertDialog(
              'Error', 'Please add a workout to start one.');
        return SinglePickerAlertDialog<Workout>(
            'Start a workout',
            'Select an option:',
            Map.fromIterable(workouts, key: (w) => w.name, value: (w) => w),
            ((Workout w) {
          goToTimer(w, context);
        }));
      });
  }

  void goToTimer(Workout workout, BuildContext dialogContext) {
    if (workout.blocks.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleMessageAlertDialog('Error', 'Please add at least one exercise.');
        },
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChangeNotifierProvider<PastWorkoutNotifier>.value(
          value: Provider.of<PastWorkoutNotifier>(this.context), 
          child: CountDownPage(workout)
        ),),
      );
    }
  }

  void addNewWorkout() {
    showDialog(
      context: context,
      builder: (_) {
        return TextInputAlertDialog('Enter workout name', (String text) {
          Workout wk = Workout(text, [
            ExerciseBlock("New exercise", 1, Duration(seconds: 30), Duration(seconds: 90)),
          ]);
          Provider.of<WorkoutNotifier>(context, listen: false).addWorkout(wk);
        }, initialValue: 'New workout');
      },
    );
  }

  void addWorkout(Workout wk) {
    Provider.of<WorkoutNotifier>(context, listen: false).addWorkout(wk);
  }

  void duplicateWorkout(Workout wk) {
    Workout wkCopy = Workout.copy(wk);
    Provider.of<WorkoutNotifier>(context, listen: false).addWorkout(wkCopy);
  }

  void removeWorkout(Workout wk) {
    showDialog(
      context: context,
      builder: (_) {
        return SingleMessageConfirmationDialog("Please confirm", "Do you really want to delete this workout?", 
        (){Provider.of<WorkoutNotifier>(context, listen: false).removeWorkout(wk);}, 
        (){});
      },
    );
  }

  void updateWorkoutName(Workout wk, String name) {
    Provider.of<WorkoutNotifier>(context, listen: false)
        .updateWorkout(wk, name: name);
  }
}
