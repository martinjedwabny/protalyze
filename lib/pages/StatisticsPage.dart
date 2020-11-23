import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/domain/ExerciseObjective.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:Protalyze/widgets/FloatingScaffold.dart';
import 'package:Protalyze/widgets/SingleMessageScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsPage extends StatelessWidget {
  final VoidCallback _logoutCallback;
  final CalendarController _calendarController = CalendarController();
  StatisticsPage(this._logoutCallback);
  @override
  Widget build(BuildContext context) {
    return FloatingScaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        actions: [
        IconButton(icon: Icon(Icons.logout, color: Themes.normal.primaryColor,), onPressed: () {
            this._logoutCallback();
          },
        ),
      ],
      ),
      body: Consumer<PastWorkoutNotifier>(builder: (context, notifier, child) {
        if (notifier.pastWorkouts.isEmpty) return SingleMessageScaffold('No registered workouts added yet.');
        return ListView(children: [
          buildCalendar(notifier.pastWorkouts),
          buildCalendarLegend(),
          buildSetStatisticsCurrentWeek(notifier.pastWorkouts),
        ],);
      })
    );
  }

  Widget buildCalendar(List<PastWorkout> pastWorkouts) {
    Map<DateTime, List<ExerciseObjective>> events = Map();
    for (PastWorkout pw in pastWorkouts) {
      events[pw.dateTime] = (events[pw.dateTime] == null ? [] : events[pw.dateTime]);
      for (var name in ExerciseObjective.names)
        if (pw.workout.objectiveCount.containsKey(ExerciseObjective(name)) &&
          pw.workout.objectiveCount[ExerciseObjective(name)] > 0)
          events[pw.dateTime].add(ExerciseObjective(name));
    }
    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarController: this._calendarController,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Themes.normal.primaryColor),
        weekdayStyle: TextStyle(color: Themes.normal.primaryColor),
      ),
      calendarStyle: CalendarStyle(
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.black),
        holidayStyle: TextStyle(color: Colors.black),
        outsideHolidayStyle: TextStyle(color: Themes.normal.disabledColor),
        outsideWeekendStyle: TextStyle(color: Themes.normal.disabledColor),
        selectedColor: Themes.normal.accentColor,
        todayColor: Themes.normal.accentColor.withOpacity(0.7),
        markersColor: Themes.normal.accentColor,
      ),
      events: events,
      builders: CalendarBuilders(
        dayBuilder: (BuildContext context, DateTime date, List events) =>
          Center(child:Container(height: 40,child:Text(date.day.toString(),))),
        todayDayBuilder: (BuildContext context, DateTime date, List events) =>
          Center(child:Container(height: 40,child:Text(date.day.toString(),style: TextStyle(color: Themes.normal.accentColor),))),
        markersBuilder: (context, date, events, holidays) =>
          [Padding(padding: EdgeInsets.only(top: 20), child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: (events == null || events.length == 0) ? 1 : 
                events.length < 4 ? events.length : 4,
              primary: false,
              padding: EdgeInsets.zero,
              childAspectRatio: 1,
              children: events.map((event) => 
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.circle, size: 17, color: Themes.normal.accentColor),
                    Text(event.name.substring(0,2), style: TextStyle(fontSize: 10, color: Colors.white),)
                  ]),
              ).toList(),
            ))],
      ),
    );
  }

  Widget buildCalendarLegend() {
    return Container(
      padding: EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        primary: false,
        padding: EdgeInsets.zero,
        childAspectRatio: 2.5,
        children: ExerciseObjective.names.map((String objectiveName) => 
          Center(
            child: Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center, 
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.circle, size: 26, color: Themes.normal.accentColor),
                    Text(objectiveName.substring(0,2), style: TextStyle(fontSize: 14, color: Colors.white),)
                  ]),
                Text(objectiveName, style: TextStyle(fontSize: 18)),
              ],
            )
          )
        ).toList(),
      ),
    );
  }

  Widget buildSetStatisticsCurrentWeek(List<PastWorkout> pastWorkouts) {
    // var d = DateTime.now();
    // var weekDay = d.weekday;
    // var firstDayOfWeek = d.subtract(Duration(days: weekDay));
    // var nextWeek = firstDayOfWeek.add(Duration(days: 7));
    // Map<ExerciseObjective(' int')> stats = Map();
    // for (PastWorkout pw in pastWorkouts) {
    //   if ((pw.dateTime.isAfter(firstDayOfWeek) || pw.dateTime.isAtSameMomentAs(firstDayOfWeek)) && (pw.dateTime.isBefore(nextWeek))) {
    //     var objectivesCount = pw.workout.objectiveCount;
    //     if (objectivesCount == null || objectivesCount.isEmpty) continue;
    //     for (var o in objectivesCount.keys) {
    //       if (stats[o] == null) stats[o] = 0;
    //       stats[o] += objectivesCount[o];
    //     }
    //   }
    // }
    // print(stats);
    // return Container(
    //   padding: EdgeInsets.all(16),
    //   child: SfCartesianChart(
    //     primaryXAxis: CategoryAxis(),
    //     // Chart title
    //     title: ChartTitle(text: 'Half yearly sales analysis'),
    //     // Enable legend
    //     legend: Legend(isVisible: true),
    //     // Enable tooltip
    //     tooltipBehavior: TooltipBehavior(enable: true),
    //     series: <ChartSeries<_SalesData, String>>[
    //       LineSeries<_SalesData, String>(
    //           dataSource: <_SalesData>[
    //             _SalesData('Jan', 35),
    //             _SalesData('Feb', 28),
    //             _SalesData('Mar', 34),
    //             _SalesData('Apr', 32),
    //             _SalesData('May', 40)
    //           ],
    //           xValueMapper: (_SalesData sales, _) => sales.year,
    //           yValueMapper: (_SalesData sales, _) => sales.sales,
    //           // Enable data label
    //           dataLabelSettings: DataLabelSettings(isVisible: true))
    //     ]
    //   )
    // );
    return Container();
  }
  
}

class PastWorkoutCalendarAdapter {

  static Map<DateTime,List<ExerciseObjective>> getItems(List<PastWorkout> source){
    Map<DateTime,List<ExerciseObjective>> items = Map<DateTime,List<ExerciseObjective>>();
    for (PastWorkout pw in source)
      for (ExerciseObjective type in pw.workout.objectiveCount.keys)
        if (pw.workout.objectiveCount[type] > 0)
          items[pw.dateTime] = items[pw.dateTime] == null ? [] : items[pw.dateTime]..add(type);
    return items;
  }
}