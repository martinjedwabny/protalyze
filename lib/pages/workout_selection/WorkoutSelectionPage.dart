import 'dart:convert';

import 'package:protalyze/common/utils/ShareHandler.dart';
import 'package:protalyze/common/utils/WorkoutFormatter.dart';
import 'package:protalyze/common/widget/FloatingScaffoldSection.dart';
import 'package:protalyze/provider/ExerciseNotifier.dart';
import 'package:protalyze/provider/PastWorkoutNotifier.dart';
import 'package:protalyze/provider/WorkoutNotifier.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/workout_selection/WorkoutListItem.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/pages/workout_display/WorkoutDisplayPage.dart';
import 'package:protalyze/common/widget/FloatingScaffold.dart';
import 'package:protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:protalyze/common/widget/SingleMessageConfirmationDialog.dart';
import 'package:protalyze/common/widget/SingleMessageScaffold.dart';
import 'package:protalyze/common/widget/TextInputAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ShareType {
  exportAsText,
  exportAsJSON,
  importAsJSON
}
class WorkoutSelectionPage extends StatefulWidget {
  final VoidCallback logoutCallback;
  const WorkoutSelectionPage(this.logoutCallback);
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> with AutomaticKeepAliveClientMixin {
  var maxJsonInputLength = 20000;

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget shareButton = IconButton(icon: Icon(Icons.share, color: Themes.normal.primaryColor,), onPressed: () {
        shareWorkoutButtonHandle();
      },
    );
    Widget newWorkoutButton = IconButton(icon: Icon(Icons.add, color: Themes.normal.primaryColor,), onPressed: () {
        addNewWorkout();
      },
    );
    Widget logoutButton = IconButton(icon: Icon(Icons.logout, color: Themes.normal.primaryColor,), onPressed: () {
        this.widget.logoutCallback();
      },
    );
    return FloatingScaffold(
      appBar: AppBar(
        title: Text('Workouts'),
        actions: [
          newWorkoutButton,
          shareButton,
          logoutButton,
      ],
      ),
      body: Consumer<WorkoutNotifier>(builder: (context, notifier, child) {
        Widget body;
        if (notifier.workouts.isEmpty)
          body = SingleMessageScaffold('No workouts added yet.');
        else 
          body = Container(child: ListView.builder(
            controller: ScrollController(),
            padding: EdgeInsets.only(bottom: 80.0),
            itemCount: notifier.workouts.length,
            itemBuilder: (context, index) {
              WorkoutListItem item = WorkoutListItem(notifier.workouts[index]);
              return buildCardForItem(item, context);
            },
          ));
        return FloatingScaffoldSection(child: body);
      }),
    );
  }

  Card buildCardForItem(WorkoutListItem item, BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 12, right: 2, top: 8, bottom: 8),
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
                  child: ChangeNotifierProvider<ExerciseNotifier>.value(
                    value: Provider.of<ExerciseNotifier>(this.context), 
                    child: WorkoutDisplayPage(item.workout)
                  ),
                ),
              ),
            ),
          );
        },
        trailing: Wrap(
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
  }

  void shareWorkoutButtonHandle() {
    List<Workout> workouts = Provider.of<WorkoutNotifier>(context, listen: false).workouts;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (workouts.isEmpty)
          return SingleMessageAlertDialog('Error', 'Please add a workout before sharing them.');
        return SimpleDialog(
          title: const Text('Share workout'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context); handleExport(ShareType.exportAsText, workouts); },
              child: const Text('Export as text'),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context); handleExport(ShareType.exportAsJSON, workouts); },
              child: const Text('Export as JSON'),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context); handleImport(); },
              child: const Text('Import JSON'),
            ),
          ],
        );
      });
  }

  void handleExport(ShareType type, List<Workout> workouts){
    showDialog(context: context, builder: (BuildContext context) => 
      SimpleDialog(
        title: Text('Choose a workout to export'),
        children: workouts.map((e) => SimpleDialogOption(
          onPressed: () { 
            String toShare = type == ShareType.exportAsText ? WorkoutFormatter.formatWorkoutToString(e) : WorkoutFormatter.formatWorkoutToJson(e);
            ShareHandler.share(toShare, () => {}, (value) => {});
            Navigator.pop(context); 
          },
          child: Text(e.name),
        )).toList()));
  }

  void handleImport(){
    showDialog(
      context: context, 
      builder: (BuildContext context) => TextInputAlertDialog(
        'Input JSON', 
        (input) { 
          print(input);
          var decodedJson = jsonDecode(input);
          print(decodedJson);
          var oldWorkout = Workout.fromJson(decodedJson);
          addWorkout(Workout.copy(oldWorkout));
        },
        multilineInput: true,
        inputMaxLength: maxJsonInputLength,));
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
