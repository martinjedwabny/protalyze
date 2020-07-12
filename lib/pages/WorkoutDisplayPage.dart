import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/bloc/WorkoutNotifier.dart';
import 'package:Protalyze/containers/ExerciseBlockListItem.dart';
import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/CountdownPage.dart';
import 'package:Protalyze/pages/ExerciseEditPage.dart';
import 'package:Protalyze/widgets/SingleMessageAlertDialog.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutDisplayPage extends StatefulWidget {
  final Workout workout;
  final List<ExerciseBlockListItem> items;
  final bool canEdit;
  
  WorkoutDisplayPage(this.workout, {this.canEdit = true}) :
    this.items = workout.exercises.map((e) => ExerciseBlockListItem(e)).toList();

  @override
  _WorkoutDisplayPageState createState() => _WorkoutDisplayPageState();
}

class _WorkoutDisplayPageState extends State<WorkoutDisplayPage> {
  @override
  Widget build(BuildContext context) {
    Widget addExerciseButton = FloatingActionButton(
      heroTag: 'ExerciseAdd',
      tooltip: 'Add exercise',
      onPressed: () { 
        addNewExercise(); 
      },
      child: Icon(Icons.add, color: Colors.white,),
    );
    Widget playButton = FloatingActionButton(
      heroTag: 'play',
      tooltip: 'Start workout',
      onPressed: () { 
        goToTimer();
      },
      child: Icon(Icons.play_arrow, color: Colors.white,),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: widget.items.isEmpty ? 
        SingleMessageScaffold('No exercises added yet.') :
        widget.canEdit == false ?
        ListView(
          children: widget.items.map((item) => createRowCard(item)).toList(),
        ) :
        ReorderableListView(
          children: widget.items.map((item) => createRowCard(item)).toList(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                reorderItems(oldIndex, newIndex);
              });
            },
          ),
      floatingActionButton: widget.canEdit == false ? playButton : Wrap(spacing: 10.0, children: [
        playButton,
        addExerciseButton,
      ] ,),
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
    ExerciseBlock blockCopy = ExerciseBlock.copy(block);
    addExercise(blockCopy);
  }

  addExercise(ExerciseBlock block) {
    setState(() {
      widget.workout.exercises.add(block);
      widget.items.add(ExerciseBlockListItem(block));
      Provider.of<WorkoutNotifier>(context, listen: false).updateWorkout(widget.workout);
    });
  }

  removeExercise(ExerciseBlock block) {
    setState(() {
      widget.workout.exercises.remove(block);
      widget.items.removeWhere((element) => element.block == block);
      Provider.of<WorkoutNotifier>(context, listen: false).updateWorkout(widget.workout);
    });
  }
  

  void updateExercise(ExerciseBlock block) {
    Provider.of<WorkoutNotifier>(context, listen: false).updateWorkout(widget.workout);
    setState(() {});
  }

  Card createRowCard(ExerciseBlockListItem item) {
    return Card(
      key: ValueKey(item),
      child: ListTile(
        title: item.buildTitle(context),
        subtitle: item.buildSubtitle(context),
        onTap: widget.canEdit == false ? ((){}) : () {
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
          children: widget.canEdit == false ? [] : <Widget>[
            IconButton(icon: Icon(Icons.add), tooltip: 'Duplicate', onPressed: () {
              duplicateExercise(item.block);
            },), // icon-1
            IconButton(icon: Icon(Icons.delete_outline), tooltip: 'Remove', onPressed: () {
              removeExercise(item.block);
            }),// icon-2
          ],
        ),
      ),
    );
  }

  void goToTimer() {
    if (this.widget.workout.exercises.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleMessageAlertDialog('Error', 'Please add at least one exercise.');
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangeNotifierProvider<PastWorkoutNotifier>.value(
          value: Provider.of<PastWorkoutNotifier>(this.context), 
          child: CountDownPage(this.widget.workout)
        ),),
      );
    }
  }
}