import 'package:Protalyze/common/widget/FloatingScaffoldSection.dart';
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
import 'package:table_calendar/table_calendar.dart';

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
  final CalendarController _calendarController = CalendarController();
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
      body: Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
        return ListView(
          padding: EdgeInsets.all(8),
          children: [
            createHeader('Workouts this month'),
            buildCalendarStatistics(notifier),
            createHeader('Latest workouts'),
            buildHistoricalPastWorkouts(notifier),
          ],
        );
      })
    );
  }

  FloatingScaffoldSection buildHistoricalPastWorkouts(PastWorkoutNotifier notifier) {
    Widget body = ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: createListItems(notifier.pastWorkouts), 
      padding: EdgeInsets.only(bottom: 80.0)
    );
    return FloatingScaffoldSection(child: body);
  }

  FloatingScaffoldSection buildCalendarStatistics(PastWorkoutNotifier notifier) {
    return FloatingScaffoldSection(
            child: StatisticsCalendar(
                  calendarController: _calendarController, 
                  pastWorkouts: notifier.pastWorkouts
                ),
            padding: EdgeInsets.zero, 
            margin: EdgeInsets.only(bottom: 16),
          );
  }

  FloatingScaffoldSection buildWeekSetsStatistics(PastWorkoutNotifier notifier) {
    return FloatingScaffoldSection(
            child: Column(
              children: [
                createHeader('Sets this week'),
                Center(
                  child:StatisticsBarChart(
                    pastWorkouts: notifier.pastWorkouts
                  )
                ),
              ], 
              crossAxisAlignment: CrossAxisAlignment.start,
            ), 
            padding: EdgeInsets.only(bottom: 16), 
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
    if (ans.isEmpty) {
      ans.add(Text('No workouts added yet.', style: Theme.of(context).textTheme.headline6,),);
    }
    return ans;
  }
}
