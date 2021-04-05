import 'package:Protalyze/common/domain/ExerciseObjective.dart';
import 'package:Protalyze/pages/statistics/ExerciseObjectiveTag.dart';
import 'package:flutter/material.dart';

class StatisticsCalendarLegend extends StatelessWidget {
  const StatisticsCalendarLegend({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        primary: false,
        padding: EdgeInsets.zero,
        childAspectRatio: 2.5,
        children: ExerciseObjective.names.map((String objectiveName) => 
          Center(
            child: Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center, 
              children: [
                ExerciseObjectiveTag(objective: ExerciseObjective(objectiveName), size: 20),
                Text(objectiveName, style: TextStyle(fontSize: 16)),
              ],
            )
          )
        ).toList(),
      ),
    );
  }
}