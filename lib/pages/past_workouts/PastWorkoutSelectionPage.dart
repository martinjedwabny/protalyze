import 'package:Protalyze/common/widget/FloatingScaffoldSection.dart';
import 'package:Protalyze/common/widget/PageableListView.dart';
import 'package:Protalyze/pages/statistics/StatisticsBarChart.dart';
import 'package:Protalyze/pages/statistics/StatisticsCalendar.dart';
import 'package:Protalyze/provider/PastWorkoutNotifier.dart';
import 'package:Protalyze/provider/WorkoutNotifier.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/pages/past_workouts/DateHeaderListItemWidget.dart';
import 'package:Protalyze/pages/past_workouts/PastWorkoutListItem.dart';
import 'package:Protalyze/common/domain/PastWorkout.dart';
import 'package:Protalyze/common/domain/Workout.dart';
import 'package:Protalyze/pages/workout_display/WorkoutDisplayPage.dart';
import 'package:Protalyze/common/widget/FloatingScaffold.dart';
import 'package:Protalyze/pages/past_workouts/PastWorkoutEditDialog.dart';
import 'package:Protalyze/pages/past_workouts/PastWorkoutListItemWidget.dart';
import 'package:Protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:Protalyze/common/widget/SingleMessageConfirmationDialog.dart';
import 'package:Protalyze/common/widget/SinglePickerAlertDialog.dart';
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
        title: Text('History'),
        actions: [
        IconButton(icon: Icon(Icons.add, color: Themes.normal.primaryColor,), onPressed: () {
            addNewPastWorkout();
          },
        ),
        IconButton(icon: Icon(Icons.logout, color: Themes.normal.primaryColor,), onPressed: () {
            this.widget.logoutCallback();
          },
        ),
      ],
      ),
      body: ListView(
          padding: EdgeInsets.all(8),
          children: [
            createHeader('Workouts this month'),
            buildCalendarStatistics(),
            createHeader('Sets this week'),
            buildWeekSetsStatistics(),
            createHeader('Latest workouts'),
            buildHistoricalPastWorkouts(),
          ],
        )
    );
  }

  Widget buildHistoricalPastWorkouts() {
    return FloatingScaffoldSection(
      child: Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
        return PageableListView(
        items: createListItems(notifier.pastWorkouts), 
        perPage: 10, 
        messageNoItems: "No workouts added yet.",
        physics: ClampingScrollPhysics(),
        shrinkWraps: true,);
      }));
  }

  Widget buildCalendarStatistics() {
    return FloatingScaffoldSection(
      child: Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
        return StatisticsCalendar(
            pastWorkouts: notifier.pastWorkouts
          );
      }),
      padding: EdgeInsets.zero, 
      margin: EdgeInsets.only(bottom: 16)
    );
  }

  Widget buildWeekSetsStatistics() {
    return FloatingScaffoldSection(
      child: Center(
        child: Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
          return StatisticsBarChart(
            pastWorkouts: notifier.pastWorkouts,
            messageNoItems: "No workouts added yet.",);
        }),
      ),
      margin: EdgeInsets.only(bottom: 16),
    );
  }

  Widget createHeader(String text){
    return Padding(
      padding: EdgeInsets.only(bottom:16), 
      child: Text(
        text, 
        style: TextStyle(fontSize: 26),
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
      ans.add(createListItem(orderedPastWorkouts, i));
    }
    return ans;
  }

  Widget createListItem(List<PastWorkout> orderedPastWorkouts, int i) {
    List<Widget> columnItems = [];
    DateTime date = orderedPastWorkouts[i].dateTime;
    String dateF = "${date.day}-${date.month}-${date.year}";
    DateTime otherDate = i == 0 ? null : orderedPastWorkouts[i - 1].dateTime;
    String otherF = i == 0
        ? null
        : "${otherDate.day}-${otherDate.month}-${otherDate.year}";
    if (dateF != otherF) {
      columnItems.add(DateHeaderListItemWidget(date));
    }
    PastWorkoutListItem item = PastWorkoutListItem(orderedPastWorkouts[i]);
    columnItems.add(PastWorkoutListItemWidget(item, 
      (){ openPastWorkoutDisplayPage(item); }, 
      (){ openPastWorkoutEditDialog(item); }, 
      (){ removePastWorkout(item.pastWorkout); }));
    return Column(
      children: columnItems,
    );
  }
}
