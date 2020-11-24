import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/common/domain/ExerciseObjective.dart';
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
}