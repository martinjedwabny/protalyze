import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/common/domain/ExerciseObjective.dart';
import 'package:Protalyze/common/domain/PastWorkout.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsCalendar extends StatelessWidget {
  const StatisticsCalendar({
    Key key,
    @required CalendarController calendarController,
    @required this.pastWorkouts,
  }) : _calendarController = calendarController, super(key: key);

  final CalendarController _calendarController;
  final List<PastWorkout> pastWorkouts;

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<ExerciseObjective>> events = Map();
    for (PastWorkout pw in pastWorkouts) {
      events[pw.dateTime] = (events[pw.dateTime] == null ? [] : events[pw.dateTime]);
      for (var name in ExerciseObjective.names)
        if (pw.workout.objectiveCount.containsKey(ExerciseObjective(name)) &&
          pw.workout.objectiveCount[ExerciseObjective(name)] > 0)
          events[pw.dateTime].add(ExerciseObjective(name));
    }
    return TableCalendar(
      availableGestures: AvailableGestures.none,
      availableCalendarFormats: const {CalendarFormat.month: ''},
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarController: this._calendarController,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Themes.normal.primaryColor),
        weekdayStyle: TextStyle(color: Themes.normal.primaryColor),
      ),
      calendarStyle: CalendarStyle(
        contentPadding: EdgeInsets.zero,
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
}