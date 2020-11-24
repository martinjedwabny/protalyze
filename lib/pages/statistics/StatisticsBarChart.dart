import 'package:Protalyze/common/domain/ExerciseObjective.dart';
import 'package:Protalyze/common/domain/PastWorkout.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsBarChart extends StatelessWidget {
  const StatisticsBarChart({
    Key key,
    @required this.pastWorkouts,
  }) : super(key: key);

  final List<PastWorkout> pastWorkouts;

  Map<ExerciseObjective,int> objectiveCountPerDayBetween(DateTime start, DateTime finish){
    Map<ExerciseObjective,int> stats = Map();
    for (PastWorkout pw in pastWorkouts) {
      bool isBetweenRange = (pw.dateTime.isAfter(start) || pw.dateTime.isAtSameMomentAs(start)) && (pw.dateTime.isBefore(finish));
      if (isBetweenRange) {
        var objectivesCount = pw.workout.objectiveCount;
        if (objectivesCount == null || objectivesCount.isEmpty) continue;
        for (var o in objectivesCount.keys) {
          // if (objectivesCount[o] == 0) continue;
          if (!stats.containsKey(o)) stats[o] = 0;
          stats[o] += objectivesCount[o];
        }
      }
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    var firstDayOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 1));
    var nextWeek = firstDayOfWeek.add(Duration(days: 7));
    Map<ExerciseObjective,int> stats = objectiveCountPerDayBetween(firstDayOfWeek, nextWeek);
    double maxY = stats.values.isEmpty ? 1 : stats.values.reduce((value, element) => value > element ? value : element).toDouble();
    return Container(
      height: 200,
      width: 430,
      child: BarChart(
        BarChartData(
          maxY: maxY * 1.2,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return null;
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              margin: 8,
              showTitles: true,
              getTextStyles: (value) => TextStyle(color: Themes.normal.primaryColor, fontSize: 12),
              getTitles: (double value) => ExerciseObjective.names.length > value.toInt() ? ExerciseObjective.names.elementAt(value.toInt()).substring(0, ExerciseObjective.names.elementAt(value.toInt()).length < 3 ? ExerciseObjective.names.elementAt(value.toInt()).length : 3) : '',
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => TextStyle(color: Themes.normal.primaryColor, fontSize: 10),
              margin: 0,
              reservedSize: 14,
              getTitles: (value) {
                if (value == 0) {
                  return '0';
                } else if (value == maxY~/2) {
                  return (maxY~/2).toString();
                } else if (value == maxY) {
                  return maxY.toInt().toString();
                } else {
                  return '';
                }
              },
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: List<BarChartGroupData>.generate(ExerciseObjective.names.length, (i) => 
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  y: stats.containsKey(ExerciseObjective(ExerciseObjective.names.elementAt(i))) ? stats[ExerciseObjective(ExerciseObjective.names.elementAt(i))].toDouble() : 0, 
                  colors: [Themes.normal.accentColor, Colors.orangeAccent], 
                  width: 20,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    y: maxY,
                    colors: [Colors.grey[100],Colors.grey[300]],
                    gradientFrom: Offset(0, 0),
                    gradientTo: Offset(0, 6),
                ),
                ),
              ],
              showingTooltipIndicators: [0],
            )
          ),
        ),
      ),
    );
  }
}