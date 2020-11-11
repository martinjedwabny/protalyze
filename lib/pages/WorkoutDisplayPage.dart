import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/bloc/WorkoutNotifier.dart';
import 'package:Protalyze/containers/BlockListItem.dart';
import 'package:Protalyze/domain/Block.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/GroupBlock.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/pages/CountdownPage.dart';
import 'package:Protalyze/pages/ExerciseEditPage.dart';
import 'package:Protalyze/widgets/GroupBlockEditDialog.dart';
import 'package:Protalyze/widgets/SingleMessageAlertDialog.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:Protalyze/widgets/TextInputAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutDisplayPage extends StatefulWidget {
  final Workout workout;
  final bool canEdit;
  
  WorkoutDisplayPage(this.workout, {this.canEdit = true});

  @override
  _WorkoutDisplayPageState createState() => _WorkoutDisplayPageState();
}

class _WorkoutDisplayPageState extends State<WorkoutDisplayPage> {
  @override
  Widget build(BuildContext context) {
    Widget addBlockButton = FloatingActionButton(
      heroTag: 'ExerciseAdd',
      tooltip: 'Add block',
      onPressed: () { 
        showAddNewBlockDialog(); 
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
      body: getListViewFromWorkout(this.widget.workout),
      floatingActionButton: widget.canEdit == false ? null : 
        Wrap(spacing: 10.0, children: [ playButton, addBlockButton, ],
      ),
    );
  }

  void showAddNewBlockDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose what to add'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () { addNewExercise(null); Navigator.pop(context); },
              child: const Text('Exercise'),
            ),
            SimpleDialogOption(
              onPressed: () { addNewGroup(null); Navigator.pop(context); },
              child: const Text('Superset'),
            ),
          ],
        );
      },
    );
  }



  Widget getListViewFromWorkout(Workout workout){
    if (workout.blocks.isEmpty)
      return SingleMessageScaffold('No exercises added yet.');
    // TODO reordering
    // if (widget.canEdit)
    //   return ReorderableListView(
    //     children: workout.map((item) => createRowCard(item)).toList(),
    //     onReorder: (oldIndex, newIndex) {
    //       setState(() {
    //         reorderItems(oldIndex, newIndex);
    //       });
    //     });
    return ListView(
      children: workout.blocks.map((item) => getWidgetFromBlock(null, item)).toList(),
    );
  }

  Widget getWidgetFromBlock(GroupBlock parent, Block block) {
    var handleAddExercise = (){
      addNewExercise(block as GroupBlock);
    };
    var handleRemove = (){
      setState(() {
        if (parent == null)
          this.widget.workout.blocks.remove(block);
        else
          parent.subBlocks.remove(block);
        Provider.of<WorkoutNotifier>(context, listen: false).updateWorkout(widget.workout);
      });
    };
    return Container(
      child: block is GroupBlock ? getWidgetFromGroupBlock(block, handleAddExercise, handleRemove) : getWidgetFromExerciseBlock(block, handleRemove));
  }

  Widget getWidgetFromGroupBlock(GroupBlock block, VoidCallback handleAddExercise, VoidCallback handleRemove) {
    GroupBlockListItem item = new GroupBlockListItem(block);
    return Card(
      color: Colors.grey[200],
      key: ValueKey(item),
      child: Container(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Column(
          children: [
            ListTile(
            title: item.buildTitle(context),
            onTap: widget.canEdit == false ? ((){}) : () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return GroupBlockEditDialog('Edit superset name', (String name, int sets) {
                    block.name = name;
                    block.sets = sets;
                    updateWorkout();
                  }, 
                  initialText: block.name, 
                  initialSets: block.sets == null ? 1 : block.sets);
                },
              );
            },
            trailing: Wrap(
              spacing: 4, // space between two icons
              children: widget.canEdit == false ? [] : <Widget>[
                IconButton(icon: Icon(Icons.add), tooltip: 'Add exercise', onPressed: () {
                  handleAddExercise();
                },), // icon-1
                IconButton(icon: Icon(Icons.delete_outline), tooltip: 'Remove', onPressed: () {
                  handleRemove();
                }),// icon-2
              ],
            ),
          ),
          ListView(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            physics: ClampingScrollPhysics(), 
            shrinkWrap: true,
            children: block.subBlocks.map((subBlock) => getWidgetFromBlock(block, subBlock)).toList(),
          ),
          ],
        )
      )
    );
  }


  Widget getWidgetFromExerciseBlock(ExerciseBlock block, VoidCallback handleRemove) {
    ExerciseBlockListItem item = new ExerciseBlockListItem(block);
    return Card(
      key: ValueKey(item),
      child: ListTile(
        title: item.buildTitle(context),
        subtitle: item.buildContent(context),
        onTap: widget.canEdit == false ? ((){}) : () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExerciseEditPage(block, updateWorkout)),
          ).then((value) {
            setState(() {
            });
          });
        },
        trailing: Wrap(
          spacing: 4, // space between two icons
          children: widget.canEdit == false ? [] : <Widget>[
            IconButton(icon: Icon(Icons.delete_outline), tooltip: 'Remove', onPressed: () {
              handleRemove();
            }),// icon-2
          ],
        ),
      ),
    );
  }

  // void reorderItems(int oldIndex, int newIndex) {
  //   if (newIndex != oldIndex) {
  //     if (oldIndex < newIndex)
  //       newIndex -= 1;
  //     ExerciseBlockListItem item = widget.items.removeAt(oldIndex);
  //     widget.items.insert(newIndex, item);
  //     List<Block> exercises = widget.workout.blocks;
  //     ExerciseBlock block = exercises.removeAt(oldIndex);
  //     exercises.insert(newIndex, block);
  //     updateExercise(block);
  //   }
  // }
  
  // duplicateExercise(ExerciseBlock block) {
  //   ExerciseBlock blockCopy = ExerciseBlock.copy(block);
  //   addExercise(blockCopy);
  // }

  void addNewExercise(GroupBlock parent){
    ExerciseBlock block = ExerciseBlock('New exercise', 1, Duration(seconds: 30), Duration(seconds: 90));
    addBlock(parent, block);
  }

  void addNewGroup(GroupBlock parent){
    GroupBlock block = GroupBlock('New Superset', 1, []);
    addBlock(parent, block);
  }

  void addBlock(GroupBlock parent, Block child) {
    setState(() {
      if (parent == null)
        this.widget.workout.blocks.add(child);
      else
        parent.subBlocks.add(child);
      Provider.of<WorkoutNotifier>(context, listen: false).updateWorkout(widget.workout);
    });
  }
  
  void updateWorkout() {
    Provider.of<WorkoutNotifier>(context, listen: false).updateWorkout(widget.workout);
    setState(() {});
  }

  void goToTimer() {
    if (this.widget.workout.blocks.isEmpty){
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