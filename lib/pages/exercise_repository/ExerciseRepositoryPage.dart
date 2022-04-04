import 'package:flutter/material.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:protalyze/common/widget/FloatingScaffold.dart';
import 'package:protalyze/common/widget/RoundedCardShape.dart';
import 'package:protalyze/common/widget/SingleMessageConfirmationDialog.dart';
import 'package:protalyze/common/widget/SingleMessageScaffold.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/exercise_edit/ExerciseEditPage.dart';
import 'package:protalyze/pages/exercise_repository/ExerciseListItem.dart';
import 'package:protalyze/provider/ExerciseNotifier.dart';
import 'package:provider/provider.dart';

class ExerciseRepositoryPage extends StatelessWidget {
  final VoidCallback logoutCallback;

  const ExerciseRepositoryPage(this.logoutCallback);

  @override
  Widget build(BuildContext context) {
    return FloatingScaffold(
      appBar: AppBar(
        title: Text('Exercises'),
        actions: [
          buildNewExerciseButton(context),
          buildLogoutButton(),
        ],
      ),
      body: Consumer<ExerciseNotifier>(builder: (_, notifier, child) {
        Widget body;
        if (notifier.exercises.isEmpty)
          body = SingleMessageScaffold('No exercises added yet.');
        else
          body = Container(
              child: ListView.builder(
            controller: ScrollController(),
            itemCount: notifier.exercises.length,
            itemBuilder: (_, index) {
              ExerciseListItem item =
                  ExerciseListItem(notifier.exercises[index]);
              return buildCardForItem(item, context);
            },
          ));
        return body;
      }),
    );
  }

  Widget buildNewExerciseButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Themes.normal.primaryColor,
      ),
      onPressed: () {
        addNewExercise(context);
      },
    );
  }

  Widget buildLogoutButton() {
    return IconButton(
      icon: Icon(
        Icons.logout,
        color: Themes.normal.primaryColor,
      ),
      onPressed: () {
        this.logoutCallback();
      },
    );
  }

  Widget buildCardForItem(item, BuildContext context) {
    return Card(
      shape: RoundedCardShape.shape,
      child: ListTile(
        shape: RoundedCardShape.shape,
        contentPadding: EdgeInsets.only(left: 12, right: 2, top: 8, bottom: 8),
        title: item.buildTitle(context),
        subtitle: item.buildContent(context),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider<ExerciseNotifier>.value(
                    value: Provider.of<ExerciseNotifier>(context),
                    child: ExerciseEditPage(item.exercise, () {
                      updateExercise(item.exercise, context);
                    })),
              ));
        },
        trailing: Wrap(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.delete_outline),
                tooltip: 'Remove',
                onPressed: () {
                  removeExercise(item.exercise, context);
                }),
          ],
        ),
      ),
    );
  }

  void removeExercise(exercise, BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return SingleMessageConfirmationDialog(
              "Please confirm", "Do you really want to delete this exercise?",
              () {
            Provider.of<ExerciseNotifier>(context, listen: false)
                .removeExerciseBlock(exercise);
          }, () {});
        });
  }

  void updateExercise(ExerciseBlock exercise, BuildContext context) {
    Provider.of<ExerciseNotifier>(context, listen: false)
        .updateExerciseBlock(exercise);
  }

  void addNewExercise(BuildContext context) {
    ExerciseBlock exercise = ExerciseBlock(
        "New exercise", 1, Duration(seconds: 30), Duration(seconds: 90));
    Provider.of<ExerciseNotifier>(context, listen: false)
        .addExerciseBlock(exercise);
  }
}
