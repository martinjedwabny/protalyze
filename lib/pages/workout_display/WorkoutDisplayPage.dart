import 'package:protalyze/common/widget/FloatingScaffoldSection.dart';
import 'package:protalyze/provider/ExerciseNotifier.dart';
import 'package:protalyze/provider/WorkoutNotifier.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/workout_display/BlockListItem.dart';
import 'package:protalyze/common/domain/Block.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:protalyze/common/domain/GroupBlock.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/pages/exercise_edit/ExerciseEditPage.dart';
import 'package:protalyze/common/widget/FloatingScaffold.dart';
import 'package:protalyze/pages/exercise_edit/GroupBlockEditDialog.dart';
import 'package:protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:protalyze/common/widget/SingleMessageScaffold.dart';
import 'package:protalyze/common/widget/TextInputAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutDisplayPage extends StatefulWidget {
  final Workout workout;
  final bool canEdit;
  final String workoutNotes;

  WorkoutDisplayPage(this.workout,
      {this.canEdit = true, this.workoutNotes = ''});

  @override
  _WorkoutDisplayPageState createState() => _WorkoutDisplayPageState();
}

class _WorkoutDisplayPageState extends State<WorkoutDisplayPage> {
  @override
  Widget build(BuildContext context) {
    Widget editButton = IconButton(
      icon: Icon(
        Icons.edit,
        color: Themes.normal.primaryColor,
      ),
      onPressed: () {
        showEditWorkoutNameDialog();
      },
    );
    Widget addBlockButton = IconButton(
      icon: Icon(
        Icons.add,
        color: Themes.normal.primaryColor,
      ),
      onPressed: () {
        showAddNewBlockDialog();
      },
    );
    return FloatingScaffold(
      appBar: AppBar(
        title: Text(
          widget.workout.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 24),
        ),
        actions: this.widget.canEdit ? [editButton, addBlockButton] : null,
      ),
      body: FloatingScaffoldSection(
          child: getListViewFromWorkout(this.widget.workout)),
    );
  }

  void showEditWorkoutNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TextInputAlertDialog(
          'Edit workout name',
          (String name) {
            this.widget.workout.name = name;
            updateWorkout();
          },
          initialValue: this.widget.workout.name,
        );
      },
    );
  }

  void showAddNewBlockDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose what to add'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                chooseExistingExercise(null);
              },
              child: const Text('Existing exercise'),
            ),
            SimpleDialogOption(
              onPressed: () {
                addNewExercise(null);
                Navigator.pop(context);
              },
              child: const Text('New exercise'),
            ),
            SimpleDialogOption(
              onPressed: () {
                addNewGroup(null);
                Navigator.pop(context);
              },
              child: const Text('Superset'),
            ),
          ],
        );
      },
    );
  }

  void chooseExistingExercise(GroupBlock parent) {
    List<ExerciseBlock> exercises =
        Provider.of<ExerciseNotifier>(context, listen: false).exercises;
    if (exercises == null || exercises.isEmpty)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleMessageAlertDialog('Error', 'No exercises added yet.');
        },
      );
    else
      showDialog(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
              title: Text('Choose an exercise to add'),
              children: exercises
                  .map((ExerciseBlock e) => SimpleDialogOption(
                        onPressed: () {
                          addExercise(e, parent);
                          Navigator.pop(context);
                        },
                        child: Text(e.name),
                      ))
                  .toList()));
  }

  Widget getNotesText() {
    if (this.widget.workoutNotes == null || this.widget.workoutNotes == '')
      return SizedBox(width: 1, height: 1);
    return Card(
      key: ValueKey(this.widget.workoutNotes),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 12),
        title: Text(
          'Notes',
          style: Theme.of(context).textTheme.headline6,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(this.widget.workoutNotes),
      ),
    );
  }

  Widget getListViewFromWorkout(Workout workout) {
    if (workout.blocks.isEmpty)
      return SingleMessageScaffold('No exercises added yet.');
    Widget notesText = getNotesText();
    return ListView(
      padding: EdgeInsets.only(bottom: 80.0),
      children: [notesText] +
          workout.blocks.map((item) => getWidgetFromBlock(null, item)).toList(),
    );
  }

  Widget getWidgetFromBlock(GroupBlock parent, Block block) {
    var handleUp = () {
      List<Block> blocks =
          parent == null ? this.widget.workout.blocks : parent.subBlocks;
      int index = blocks.indexOf(block);
      if (index == 0) return;
      blocks.removeAt(index);
      blocks.insert(index - 1, block);
      updateWorkout();
    };
    var handleDown = () {
      List<Block> blocks =
          parent == null ? this.widget.workout.blocks : parent.subBlocks;
      int index = blocks.indexOf(block);
      if (index == blocks.length - 1) return;
      blocks.removeAt(index);
      blocks.insert(index + 1, block);
      updateWorkout();
    };
    var handleAddExercise = () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Choose what to add'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  chooseExistingExercise(block);
                },
                child: const Text('Existing exercise'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  addNewExercise(block);
                  Navigator.pop(context);
                },
                child: const Text('New exercise'),
              ),
            ],
          );
        },
      );
    };
    var handleRemove = () {
      setState(() {
        if (parent == null)
          this.widget.workout.blocks.remove(block);
        else
          parent.subBlocks.remove(block);
        Provider.of<WorkoutNotifier>(context, listen: false)
            .updateWorkout(widget.workout);
      });
    };
    return block is GroupBlock
        ? getWidgetFromGroupBlock(
            block, handleAddExercise, handleRemove, handleUp, handleDown)
        : getWidgetFromExerciseBlock(block, handleRemove, handleUp, handleDown);
  }

  Widget getWidgetFromGroupBlock(
      GroupBlock block,
      VoidCallback handleAddExercise,
      VoidCallback handleRemove,
      VoidCallback handleUp,
      VoidCallback handleDown) {
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
                  onTap: widget.canEdit == false
                      ? (() {})
                      : () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GroupBlockEditDialog(
                                  'Edit number of supersets', (int sets) {
                                block.sets = sets;
                                updateWorkout();
                              },
                                  initialSets:
                                      block.sets == null ? 1 : block.sets);
                            },
                          );
                        },
                  trailing: Wrap(
                    spacing: 0.0, // space between two icons
                    children: widget.canEdit == false
                        ? []
                        : <Widget>[
                            IconButton(
                              icon: Icon(Icons.add),
                              tooltip: 'Add exercise',
                              padding: EdgeInsets.all(4),
                              onPressed: () {
                                handleAddExercise();
                              },
                            ),
                            IconButton(
                                icon: Icon(Icons.arrow_upward),
                                tooltip: 'Up',
                                padding: EdgeInsets.all(4),
                                onPressed: () {
                                  handleUp();
                                }),
                            IconButton(
                                icon: Icon(Icons.arrow_downward),
                                tooltip: 'Down',
                                padding: EdgeInsets.all(4),
                                onPressed: () {
                                  handleDown();
                                }),
                            IconButton(
                                icon: Icon(Icons.delete_outline),
                                tooltip: 'Remove',
                                padding: EdgeInsets.all(4),
                                onPressed: () {
                                  handleRemove();
                                }),
                          ],
                  ),
                ),
                ListView(
                  padding: EdgeInsets.all(0),
                  controller: ScrollController(),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: block.subBlocks
                      .map((subBlock) => getWidgetFromBlock(block, subBlock))
                      .toList(),
                ),
              ],
            )));
  }

  Widget getWidgetFromExerciseBlock(
      ExerciseBlock block,
      VoidCallback handleRemove,
      VoidCallback handleUp,
      VoidCallback handleDown) {
    ExerciseBlockListItem item = new ExerciseBlockListItem(block);
    return Card(
      key: ValueKey(item),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 12),
        title: item.buildTitle(context),
        subtitle: item.buildContent(context),
        onTap: widget.canEdit == false
            ? (() {})
            : () {
                editExercise(block);
              },
        trailing: Wrap(
          spacing: 0.0, // space between two icons
          children: widget.canEdit == false
              ? []
              : <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_upward),
                      tooltip: 'Up',
                      padding: EdgeInsets.all(4),
                      onPressed: () {
                        handleUp();
                      }),
                  IconButton(
                      icon: Icon(Icons.arrow_downward),
                      tooltip: 'Down',
                      padding: EdgeInsets.all(4),
                      onPressed: () {
                        handleDown();
                      }),
                  IconButton(
                      icon: Icon(Icons.delete_outline),
                      tooltip: 'Remove',
                      padding: EdgeInsets.all(4),
                      onPressed: () {
                        handleRemove();
                      }),
                ],
        ),
      ),
    );
  }

  void editExercise(ExerciseBlock block) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ExerciseEditPage(block, updateWorkout)),
    );
  }

  void addExercise(ExerciseBlock ex, GroupBlock parent) {
    addBlock(parent, ex);
  }

  void addNewExercise(GroupBlock parent) {
    ExerciseBlock block = ExerciseBlock(
        'New exercise', 1, Duration(seconds: 30), Duration(seconds: 90));
    addBlock(parent, block);
  }

  void addNewGroup(GroupBlock parent) {
    GroupBlock block = GroupBlock('Superset', 1, [
      ExerciseBlock(
          'New exercise', 1, Duration(seconds: 30), Duration(seconds: 90)),
    ]);
    addBlock(parent, block);
  }

  void addBlock(GroupBlock parent, Block child) {
    if (parent != null && parent.subBlocks.length >= 30) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleMessageAlertDialog('Error', 'Limit exceeded.');
        },
      );
    } else {
      setState(() {
        if (parent == null)
          this.widget.workout.blocks.add(child);
        else
          parent.subBlocks.add(child);
        Provider.of<WorkoutNotifier>(context, listen: false)
            .updateWorkout(widget.workout);
      });
    }
  }

  void updateWorkout() {
    Provider.of<WorkoutNotifier>(context, listen: false)
        .updateWorkout(widget.workout);
    setState(() {});
  }
}
