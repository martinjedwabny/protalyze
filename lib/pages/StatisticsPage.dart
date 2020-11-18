import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/domain/ExerciseObjective.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:Protalyze/widgets/FloatingScaffold.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class StatisticsPage extends StatelessWidget {
  final VoidCallback logoutCallback;
  const StatisticsPage(this.logoutCallback);
  @override
  Widget build(BuildContext context) {
    return FloatingScaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        actions: [
        IconButton(icon: Icon(Icons.logout, color: Themes.normal.primaryColor,), onPressed: () {
            this.logoutCallback();
          },
        ),
      ],
      ),
      body: Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
        if (notifier.pastWorkouts.isEmpty) return SingleMessageScaffold('No registered workouts added yet.');
        return ListView(children: [
          buildCalendar(notifier.pastWorkouts),
          buildCalendarLegend(),
          buildSetStatistics(notifier.pastWorkouts),
        ],);
      })
    );
  }

  Widget buildCalendar(List<PastWorkout> pastWorkouts) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SfCalendar(
        headerHeight: 0,
        viewHeaderStyle: ViewHeaderStyle(
          dateTextStyle: GoogleFonts.titilliumWebTextTheme().headline6,
          dayTextStyle: GoogleFonts.titilliumWebTextTheme().headline6
        ),
        firstDayOfWeek: 1,
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
        view: CalendarView.month,
        dataSource: PastWorkoutCalendarDataSource(pastWorkouts),
        monthViewSettings: MonthViewSettings(
          appointmentDisplayCount: 8,
          numberOfWeeksInView: 5,
          monthCellStyle: MonthCellStyle(
            todayBackgroundColor: Colors.transparent
          )
        ),
      )
    );
  }

  Widget buildCalendarLegend() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Icons.circle, size: 16, color: ExerciseObjectiveTypeToColorAdapter.getColor(ExerciseObjectiveType.Chest)),
            SizedBox.fromSize(size: Size(4, 0),),
            Text('Chest', style: TextStyle(fontSize: 18)),
          ],),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Icons.circle, size: 16, color: ExerciseObjectiveTypeToColorAdapter.getColor(ExerciseObjectiveType.Back)),
            SizedBox.fromSize(size: Size(4, 0),),
            Text('Back', style: TextStyle(fontSize: 18)),
          ],),
        ],),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Icons.circle, size: 16, color: ExerciseObjectiveTypeToColorAdapter.getColor(ExerciseObjectiveType.Shoulders)),
            SizedBox.fromSize(size: Size(4, 0),),
            Text('Shoulders', style: TextStyle(fontSize: 18)),
          ],),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Icons.circle, size: 16, color: ExerciseObjectiveTypeToColorAdapter.getColor(ExerciseObjectiveType.Legs)),
            SizedBox.fromSize(size: Size(4, 0),),
            Text('Legs', style: TextStyle(fontSize: 18)),
          ],),
        ],),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Icons.circle, size: 16, color: ExerciseObjectiveTypeToColorAdapter.getColor(ExerciseObjectiveType.Biceps)),
            SizedBox.fromSize(size: Size(4, 0),),
            Text('Biceps', style: TextStyle(fontSize: 18)),
          ],),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Icons.circle, size: 16, color: ExerciseObjectiveTypeToColorAdapter.getColor(ExerciseObjectiveType.Triceps)),
            SizedBox.fromSize(size: Size(4, 0),),
            Text('Triceps', style: TextStyle(fontSize: 18)),
          ],),
        ],),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Icons.circle, size: 16, color: ExerciseObjectiveTypeToColorAdapter.getColor(ExerciseObjectiveType.Abs)),
            SizedBox.fromSize(size: Size(4, 0),),
            Text('Abs', style: TextStyle(fontSize: 18)),
          ],),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Icons.circle, size: 16, color: ExerciseObjectiveTypeToColorAdapter.getColor(ExerciseObjectiveType.Cardio)),
            SizedBox.fromSize(size: Size(4, 0),),
            Text('Cardio', style: TextStyle(fontSize: 18)),
          ],),
        ],),
      ],
      )
    );
  }

  Widget buildSetStatistics(List<PastWorkout> pastWorkouts) {
    return Container(
      padding: EdgeInsets.all(16),
    );
  }
  
}

class PastWorkoutCalendarDataSource extends CalendarDataSource {
  PastWorkoutCalendarDataSource(List<PastWorkout> source){
    appointments = List<MapEntry<DateTime,ExerciseObjectiveType>>();
    for (PastWorkout pw in source)
      for (ExerciseObjectiveType type in pw.workout.objectives)
        appointments.add(MapEntry(pw.dateTime, type));
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments[index] as MapEntry<DateTime,ExerciseObjectiveType>).key;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments[index] as MapEntry<DateTime,ExerciseObjectiveType>).key;
  }

  @override
  String getSubject(int index) {
    return (appointments[index] as MapEntry<DateTime,ExerciseObjectiveType>).value.toString();
  }

  @override
  Color getColor(int index) {
    return ExerciseObjectiveTypeToColorAdapter.getColor((appointments[index] as MapEntry<DateTime,ExerciseObjectiveType>).value);
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}

class ExerciseObjectiveTypeToColorAdapter {
  static Color getColor(ExerciseObjectiveType type) {
    switch (type) {
      case ExerciseObjectiveType.Chest:
        return Colors.blue;
      case ExerciseObjectiveType.Back:
        return Colors.red;
      case ExerciseObjectiveType.Shoulders:
        return Colors.yellow;
      case ExerciseObjectiveType.Legs:
        return Colors.green;
      case ExerciseObjectiveType.Biceps:
        return Colors.orange;
      case ExerciseObjectiveType.Triceps:
        return Colors.purple;
      case ExerciseObjectiveType.Abs:
        return Colors.brown;
      case ExerciseObjectiveType.Cardio:
        return Colors.lightBlueAccent;
      default:
        return Colors.black;
    }
  }
}