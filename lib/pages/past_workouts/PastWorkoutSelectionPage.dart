import 'package:protalyze/common/widget/FloatingScaffoldSection.dart';
import 'package:protalyze/common/widget/PageableListView.dart';
import 'package:protalyze/common/widget/PastWorkoutSaveAlertDialog.dart';
import 'package:protalyze/pages/statistics/StatisticsBarChart.dart';
import 'package:protalyze/pages/statistics/StatisticsCalendar.dart';
import 'package:protalyze/provider/PastWorkoutNotifier.dart';
import 'package:protalyze/provider/WorkoutNotifier.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/past_workouts/DateHeaderListItemWidget.dart';
import 'package:protalyze/pages/past_workouts/PastWorkoutListItem.dart';
import 'package:protalyze/common/domain/PastWorkout.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/pages/workout_display/WorkoutDisplayPage.dart';
import 'package:protalyze/common/widget/FloatingScaffold.dart';
import 'package:protalyze/pages/past_workouts/PastWorkoutEditDialog.dart';
import 'package:protalyze/pages/past_workouts/PastWorkoutListItemWidget.dart';
import 'package:protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:protalyze/common/widget/SingleMessageConfirmationDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastWorkoutSelectionPage extends StatefulWidget {
  final VoidCallback logoutCallback;
  const PastWorkoutSelectionPage(this.logoutCallback);
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
    return FloatingScaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Themes.normal.primaryColor,
              ),
              onPressed: () {
                addNewPastWorkout();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Themes.normal.primaryColor,
              ),
              onPressed: () {
                this.widget.logoutCallback();
              },
            ),
          ],
        ),
        body: ListView(
          controller: ScrollController(),
          padding: EdgeInsets.all(8),
          children: [
            createHeader('Workouts this month'),
            buildCalendarStatistics(),
            createHeader('Sets this week'),
            buildWeekSetsStatistics(),
            createHeader('Latest workouts'),
            buildHistoricalPastWorkouts(),
          ],
        ));
  }

  Widget buildHistoricalPastWorkouts() {
    return FloatingScaffoldSection(child:
        Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
      return PageableListView(
        items: createListItems(notifier.pastWorkouts),
        perPage: 10,
        messageNoItems: "No workouts added yet.",
        physics: ClampingScrollPhysics(),
        shrinkWraps: true,
      );
    }));
  }

  Widget buildCalendarStatistics() {
    return FloatingScaffoldSection(
        child:
            Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
          return StatisticsCalendar(pastWorkouts: notifier.pastWorkouts);
        }),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(bottom: 16));
  }

  Widget buildWeekSetsStatistics() {
    return FloatingScaffoldSection(
      child: Center(
        child:
            Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
          return StatisticsBarChart(
            pastWorkouts: notifier.pastWorkouts,
            messageNoItems: "No sets performed this week.",
          );
        }),
      ),
      margin: EdgeInsets.only(bottom: 16),
    );
  }

  Widget createHeader(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(fontSize: 26),
      ),
    );
  }

  void addNewPastWorkout() {
    List<Workout> workouts =
        Provider.of<WorkoutNotifier>(context, listen: false).workouts;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (workouts.isEmpty)
            return SingleMessageAlertDialog(
                'Error', 'Please add a workout before registering them.');
          return PastWorkoutSaveAlertDialog(workouts.asMap(),
              ((Workout selected, DateTime date, String notes) {
            PastWorkout pastWorkout = PastWorkout(selected, date, notes);
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
        return SingleMessageConfirmationDialog(
            "Please confirm", "Do you really want to delete this workout?", () {
          Provider.of<PastWorkoutNotifier>(context, listen: false)
              .removePastWorkout(wk);
        }, () {});
      },
    );
  }

  void updatePastWorkout(
      PastWorkout wk, String text, DateTime date, String notes) {
    Provider.of<PastWorkoutNotifier>(context, listen: false)
        .updatePastWorkout(wk, name: text, date: date, notes: notes);
  }

  void openPastWorkoutEditDialog(PastWorkoutListItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PastWorkoutEditDialog(
            'Edit workout',
            item.pastWorkout.workout.name,
            item.pastWorkout.dateTime,
            item.pastWorkout.notes,
            (String text, DateTime selectedDate, String notes) {
          updatePastWorkout(item.pastWorkout, text, selectedDate, notes);
        });
      },
    );
  }

  void openPastWorkoutDisplayPage(PastWorkoutListItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkoutDisplayPage(
                item.pastWorkout.workout,
                canEdit: false,
                workoutNotes: item.pastWorkout.notes,
              )),
    );
  }

  List<Widget> createListItems(List<PastWorkout> pastW) {
    List<PastWorkout> orderedPastWorkouts = pastW.toList();
    orderedPastWorkouts.sort((a, b) => -a.dateTime.compareTo(b.dateTime));
    List<Widget> ans = [];
    for (int i = 0; i < orderedPastWorkouts.length; i++) {
      ans.add(createListItem(orderedPastWorkouts, i));
    }
    return ans;
  }

  Widget createListItem(List<PastWorkout> orderedPastWorkouts, int i) {
    List<Widget> columnItems = [];
    DateTime date = orderedPastWorkouts[i].dateTime;
    String dateF = "${date.day}-${date.month}-${date.year}";
    DateTime otherDate = i == 0 ? null : orderedPastWorkouts[i - 1].dateTime;
    String otherF =
        i == 0 ? null : "${otherDate.day}-${otherDate.month}-${otherDate.year}";
    if (dateF != otherF) {
      columnItems.add(DateHeaderListItemWidget(date));
    }
    PastWorkoutListItem item = PastWorkoutListItem(orderedPastWorkouts[i]);
    columnItems.add(PastWorkoutListItemWidget(item, () {
      openPastWorkoutDisplayPage(item);
    }, () {
      openPastWorkoutEditDialog(item);
    }, () {
      removePastWorkout(item.pastWorkout);
    }));
    return Column(
      children: columnItems,
    );
  }
}
