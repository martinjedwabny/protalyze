import 'dart:math';

import 'package:flutter/material.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/countdown/CountdownElement.dart';

class CountdownExercisesInfo extends StatefulWidget {
  const CountdownExercisesInfo(this._controller, this._countdownElementList, this._currentCountdownElementIndex, this._totalTime);
  final AnimationController _controller;
  final List<CountdownElement> _countdownElementList;
  final Function _currentCountdownElementIndex;
  final Duration _totalTime;
  @override
  _CountdownExercisesInfoState createState() => _CountdownExercisesInfoState();
}

class _CountdownExercisesInfoState extends State<CountdownExercisesInfo> {

  final Color mainTextColor = Themes.normal.colorScheme.primary;
  final Color fadedTextColor = Themes.normal.colorScheme.primary.withAlpha(200);
  var titleFontSize = 20.0;
  var timeFontSize = 20.0;
  var exerciseFontSize = 20.0;

  @override
  Widget build(BuildContext context) {
      return Container(width: double.infinity,child: buildNextExercisesSection());
  }

  Widget buildNextExercisesSection() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Text('TOTAL', style: TextStyle(fontSize: titleFontSize),),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(8),
            child: buildTotalTimeWidget(),
          ),
        ],
      ),
      Container(
        alignment: Alignment.centerLeft,
        height: 50,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        ),
        child: buildNextExercisesWidget(),
        ),
      
    ],
  );

  Widget buildTotalTimeWidget() {
    return Text(
        totalRemainingTimeString,
        style: TextStyle(
          height: 0.95,
          fontSize: timeFontSize, 
          color: Themes.normal.colorScheme.primary,)
    );
  }

  bool isCountdownFinished() {
    return this.widget._currentCountdownElementIndex() == this.widget._countdownElementList.length;
  }

  String get blockRemainingTimeString {
    return DurationFormatter.format(this.widget._controller.duration * this.widget._controller.value);
  }

  String get totalRemainingTimeString {
    if (isCountdownFinished())
      return DurationFormatter.format(this.widget._totalTime);
    return DurationFormatter.format(this.widget._totalTime - this.widget._controller.duration * (1.0 - this.widget._controller.value));
  }

  Widget finishedMessageText() {
    return Container(child: Text(
        'FINISHED',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: exerciseFontSize, color: mainTextColor),
      ));
  }

  Widget buildNextExercisesWidget() {
    List<String> listElements = this.widget._countdownElementList.sublist(min(this.widget._currentCountdownElementIndex()+1,this.widget._countdownElementList.length)).map((e) => e.name.substring(0, e.name.length < 20 ? e.name.length : 20) + ' (' + DurationFormatter.format(e.totalTime) + ')').toList();
    if (listElements.isEmpty)
      return finishedMessageText();
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: listElements.asMap().entries.map((entry) {
        String e = entry.value;
        bool shouldTrailing = entry.key != listElements.length - 1;
        String text = shouldTrailing ? e + ' \u22C5 ' : e;
        return Container(
          margin: EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          child: Text(text, style: TextStyle(color: fadedTextColor, fontSize: exerciseFontSize, height: 1), textAlign: TextAlign.center),
        );
      }
      ).toList(),
  );
  }
}