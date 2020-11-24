import 'package:Protalyze/pages/statistics/StatisticsBarChart.dart';
import 'package:Protalyze/pages/statistics/StatisticsCalendar.dart';
import 'package:Protalyze/pages/statistics/StatisticsCalendarLegend.dart';
import 'package:Protalyze/provider/PastWorkoutNotifier.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/common/widget/FloatingScaffold.dart';
import 'package:Protalyze/common/widget/SingleMessageScaffold.dart';
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
        if (notifier.pastWorkouts.isEmpty) 
          return SingleMessageScaffold('No registered workouts added yet.');
        else
          return ListView(padding: EdgeInsets.all(8),children: [
            createHeader('This week'),
            StatisticsBarChart(pastWorkouts: notifier.pastWorkouts),
            createHeader('This month'),
            StatisticsCalendar(calendarController: _calendarController, pastWorkouts: notifier.pastWorkouts),
            StatisticsCalendarLegend(),
          ],);
      })
    );
  }

  Widget createHeader(String text){
    return Padding(
      padding: EdgeInsets.only(left:8,right:8,bottom:8, top:8), 
      child: Text(
        text, 
        style: TextStyle(fontSize: 26),
      ),
    );
  }
  
}