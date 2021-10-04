import 'dart:math';

import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/common/domain/PastWorkout.dart';
import 'package:protalyze/pages/statistics/CalendarLineTag.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsCalendar extends StatelessWidget {
  const StatisticsCalendar({
    Key key,
    @required this.pastWorkouts,
  }) : super(key: key);

  final List<PastWorkout> pastWorkouts;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(Duration(days: 365 * 20)),
      lastDay: DateTime.now().add(Duration(days: 365 * 20)),
      focusedDay: DateTime.now(),
      availableGestures: AvailableGestures.none,
      availableCalendarFormats: const {CalendarFormat.month: ''},
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Themes.normal.primaryColor),
        weekdayStyle: TextStyle(color: Themes.normal.primaryColor),
      ),
      eventLoader: getPastWorkoutForDate,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) => Center(child:Container(height: 110,child:Text(day.day.toString(),))),
        todayBuilder: (context, day, focusedDay) => Center(child:Container(height: 110,child:Text(day.day.toString(),style: TextStyle(color: Themes.normal.accentColor),),),),
        disabledBuilder: (context, day, focusedDay) => Center(child:Container(height: 110,child:Text(day.day.toString(),style: TextStyle(color: Themes.normal.disabledColor),),),),
        outsideBuilder: (context, day, focusedDay) => Center(child:Container(height: 110,child:Text(day.day.toString(),style: TextStyle(color: Themes.normal.disabledColor),),),),
        markerBuilder: (context, day, events) => 
          Padding(padding: EdgeInsets.only(top: 18, left: 4, right: 4),
            child: Column(children: getEventMarkers(events)),
          ),
      ),
    );
  }

  List<PastWorkout> getPastWorkoutForDate(DateTime day) {
    List<PastWorkout> events = [];
    for (PastWorkout pw in pastWorkouts) {
      if(pw.dateTime.year==day.year && pw.dateTime.month==day.month && pw.dateTime.day==day.day) {
        events.add(pw);
      }
    }
    return events;
  }

  List<Widget> getEventMarkers(List<PastWorkout> events) {
    List<Widget> ans = [];
    int maxMarkers = 2;
    for (int i = 0; i < min(events.length, maxMarkers); i++) {
      PastWorkout pw = events[i];
      ans.add(CalendarLineTag(message: pw.workout.name, index: i));
    }
    if (events.length > maxMarkers) {
      ans.add(CalendarLineTag(message: '+ ' + (events.length-maxMarkers).toString(), index: maxMarkers));
    }
    return ans;
  }
}