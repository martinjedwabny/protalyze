import 'dart:math';

import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/common/domain/PastWorkout.dart';
import 'package:Protalyze/pages/statistics/CalendarLineTag.dart';
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
      events: getPastWorkoutPerDate(),
      builders: CalendarBuilders(
        dayBuilder: (BuildContext context, DateTime date, List events) =>
          Center(child:Container(height: 40,child:Text(date.day.toString(),))),
        todayDayBuilder: (BuildContext context, DateTime date, List events) =>
          Center(child:Container(height: 40,child:Text(date.day.toString(),style: TextStyle(color: Themes.normal.accentColor),))),
        markersBuilder: (context, date, events, holidays) => [  
          Padding(padding: EdgeInsets.only(top: 34, left: 8, right: 8),
              child: Column(
                children: getEventMarkers(events)
              ),
          ),
        ]
      ),
    );
  }

  Map<DateTime, List<PastWorkout>> getPastWorkoutPerDate() {
    Map<DateTime, List<PastWorkout>> events = Map();
    for (PastWorkout pw in pastWorkouts) {
      DateTime date = DateTime(pw.dateTime.year, pw.dateTime.month, pw.dateTime.day);
      events[date] = (events[date] == null ? [] : events[date]);
      events[date].add(pw);
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
      ans.add(CalendarLineTag(message: '+ ' + (events.length-maxMarkers).toString() + ' more', index: maxMarkers));
    }
    return ans;
  }
}