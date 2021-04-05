import 'package:Protalyze/common/widget/FloatingScaffoldSection.dart';
import 'package:Protalyze/provider/PastWorkoutNotifier.dart';
import 'package:Protalyze/provider/WorkoutNotifier.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/pages/workout_display/BlockListItem.dart';
import 'package:Protalyze/common/domain/Block.dart';
import 'package:Protalyze/common/domain/ExerciseBlock.dart';
import 'package:Protalyze/common/domain/GroupBlock.dart';
import 'package:Protalyze/common/domain/Workout.dart';
import 'package:Protalyze/pages/countdown/CountdownPage.dart';
import 'package:Protalyze/pages/exercise_edit/ExerciseEditPage.dart';
import 'package:Protalyze/common/widget/FloatingScaffold.dart';
import 'package:Protalyze/pages/exercise_edit/GroupBlockEditDialog.dart';
import 'package:Protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:Protalyze/common/widget/SingleMessageScaffold.dart';
import 'package:Protalyze/common/widget/TextInputAlertDialog.dart';
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
    Widget playButton = FloatingActionButton(
      heroTag: 'play',
      tooltip: 'Start workout',
      onPressed: () { 
        goToTimer();
      },
      child: Icon(Icons.play_arrow, color: Colors.white,),
    );
    Widget editButton = IconButton(icon: Icon(Icons.edit, color: Themes.normal.primaryColor,), onPressed: () {
        showEditWorkoutNameDialog();
      },
    );
    Widget addBlockButton = IconButton(icon: Icon(Icons.add, color: Themes.normal.primaryColor,), onPressed: () {
        showAddNewBlockDialog();
      },
    );
    return FloatingScaffold(
      appBar: AppBar(
        title: Text(
          widget.workout.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 24
          ),
        ),
        actions: this.widget.canEdit ? [editButton, addBlockButton] : null,
      ),
      body: FloatingScaffoldSection(child: getListViewFromWorkout(this.widget.workout)),
      floatingActionButton: widget.canEdit == false ? null : playButton,
    );
  }

  void showEditWorkoutNameDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TextInputAlertDialog('Edit workout name', (String name) {
          this.widget.workout.name = name;
          updateWorkout();
        }, initialValue: this.widget.workout.name,);
      },
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
    return ListView(
      padding: EdgeInsets.only(bottom: 80.0),
      children: workout.blocks.map((item) => getWidgetFromBlock(null, item)).toList(),
    );
  }

  Widget getWidgetFromBlock(GroupBlock parent, Block block) {
    var handleUp = (){
      List<Block> blocks = parent == null ? this.widget.workout.blocks : parent.subBlocks;
      int index = blocks.indexOf(block);
      if (index == 0) return;
      blocks.removeAt(index);
      blocks.insert(index-1, block);
      updateWorkout();
    };
    var handleDown = (){
      List<Block> blocks = parent == null ? this.widget.workout.blocks : parent.subBlocks;
      int index = blocks.indexOf(block);
      if (index == blocks.length - 1) return;
      blocks.removeAt(index);
      blocks.insert(index+1, block);
      updateWorkout();
    };
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
    return block is GroupBlock ? getWidgetFromGroupBlock(block, handleAddExercise, handleRemove, handleUp, handleDown) : getWidgetFromExerciseBlock(block, handleRemove, handleUp, handleDown);
  }

  Widget getWidgetFromGroupBlock(GroupBlock block, VoidCallback handleAddExercise, VoidCallback handleRemove, VoidCallback handleUp, VoidCallback handleDown) {
    GroupBlockListItem item = new GroupBlockListItem(block);
    return Card(
      color: Colors.grey[200],
      key: ValueKey(item),
      child: Container(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 12, right: 4),
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
              spacing: 0.0, // space between two icons
              children: widget.canEdit == false ? [] : <Widget>[
                IconButton(icon: Icon(Icons.add), tooltip: 'Add exercise', 
                padding: EdgeInsets.all(4),
                onPressed: () {
                  handleAddExercise();
                },),
                IconButton(icon: Icon(Icons.arrow_upward), tooltip: 'Up', 
                padding: EdgeInsets.all(4),
                onPressed: () {
                  handleUp();
                }),
                IconButton(icon: Icon(Icons.arrow_downward), tooltip: 'Down', 
                padding: EdgeInsets.all(4),
                onPressed: () {
                  handleDown();
                }),
                IconButton(icon: Icon(Icons.delete_outline), tooltip: 'Remove', 
                padding: EdgeInsets.all(4),
                onPressed: () {
                  handleRemove();
                }),
              ],
            ),
          ),
          ListView(
            padding: EdgeInsets.all(0),
            physics: ClampingScrollPhysics(), 
            shrinkWrap: true,
            children: block.subBlocks.map((subBlock) => getWidgetFromBlock(block, subBlock)).toList(),
          ),
          ],
        )
      )
    );
  }


  Widget getWidgetFromExerciseBlock(ExerciseBlock block, VoidCallback handleRemove, VoidCallback handleUp, VoidCallback handleDown) {
    ExerciseBlockListItem item = new ExerciseBlockListItem(block);
    return Card(
      key: ValueKey(item),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 12),
        title: item.buildTitle(context),
        subtitle: item.buildContent(context),
        onTap: widget.canEdit == false ? ((){}) : () {
          editExercise(block);
        },
        trailing: Wrap(
          spacing: 0.0, // space between two icons
          children: widget.canEdit == false ? [] : <Widget>[
            IconButton(icon: Icon(Icons.arrow_upward), tooltip: 'Up', 
            padding: EdgeInsets.all(4),
            onPressed: () {
              handleUp();
            }),
            IconButton(icon: Icon(Icons.arrow_downward), tooltip: 'Down', 
            padding: EdgeInsets.all(4),
            onPressed: () {
              handleDown();
            }),
            IconButton(icon: Icon(Icons.delete_outline), tooltip: 'Remove', 
            padding: EdgeInsets.all(4),
            onPressed: () {
              handleRemove();
            }),
          ],
        ),
      ),
    );
  }

  void editExercise(ExerciseBlock block){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseEditPage(block, updateWorkout)),
    );
  }
  
  void addNewExercise(GroupBlock parent){
    ExerciseBlock block = ExerciseBlock('New exercise', 1, Duration(seconds: 30), Duration(seconds: 90));
    addBlock(parent, block);
  }

  void addNewGroup(GroupBlock parent){
    GroupBlock block = GroupBlock('Superset', 1, [
      ExerciseBlock('New exercise', 1, Duration(seconds: 30), Duration(seconds: 90)),
    ]);
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