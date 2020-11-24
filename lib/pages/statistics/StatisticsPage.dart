import 'package:Protalyze/common/widget/FloatingScaffoldSection.dart';
import 'package:Protalyze/pages/statistics/StatisticsBarChart.dart';
import 'package:Protalyze/pages/statistics/StatisticsCalendar.dart';
import 'package:Protalyze/pages/statistics/StatisticsCalendarLegend.dart';
import 'package:Protalyze/provider/PastWorkoutNotifier.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/common/widget/FloatingScaffold.dart';
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
        return ListView(
          padding: EdgeInsets.all(8),
          children: [
            FloatingScaffoldSection(
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
              padding: EdgeInsets.only(bottom: 8), 
              margin: EdgeInsets.only(bottom: 16),
            ),
            FloatingScaffoldSection(
              child: Column(
                children: [
                  createHeader('Workouts this month'),
                  StatisticsCalendar(
                    calendarController: _calendarController, 
                    pastWorkouts: notifier.pastWorkouts
                  ),
                  StatisticsCalendarLegend(),
                ], 
                crossAxisAlignment: CrossAxisAlignment.start,
              ), 
              padding: EdgeInsets.zero
            ),
          ],
        );
      })
    );
  }

  Widget createHeader(String text){
    return Padding(
      padding: EdgeInsets.only(left:16,right:16, top:16), 
      child: Text(
        text, 
        style: TextStyle(fontSize: 26),
      ),
    );
  }
  
}

