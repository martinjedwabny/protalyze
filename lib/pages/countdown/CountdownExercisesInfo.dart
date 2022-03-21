import 'dart:math';

import 'package:flutter/material.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';
import 'package:protalyze/common/utils/GifHandler.dart';
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
  var timeFontSize = 40.0;
  var exerciseFontSize = 24.0;

  @override
  Widget build(BuildContext context) {
    if (isCountdownFinished()) {
      return finishedMessageText();
    } else {
      var currentExerciseTextContainer = null;//currentExerciseText();
      if (this.widget._countdownElementList.length == 1)
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            currentExerciseTextContainer
          ]
        );
      var nextExercisesTitle = afterMessageText();
      var nextExercisesList = createNextExercisesList();
      // return Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //       currentExerciseTextContainer,
      //       nextExercisesTitle,
      //       nextExercisesList,
      //   ]
      // );
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Center(child: buildCurrentExerciseSection())),
          VerticalDivider(width: 16.0),
          Expanded(child: Center(child: buildNextExercisesSection())),
        ],
      );
    }
  }

  Widget buildCurrentExerciseSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.only(left: 8),
        child: Text('NOW', style: TextStyle(fontSize: 20.0),),
      ),
      Container(
        height: 40,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        ),
        child: buildCurrentExerciseWidget(),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(8),
          child: buildCurrentTimeWidget(),
        ),
    ],
  );

  Widget buildNextExercisesSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.only(left: 8),
        child: Text('AFTER', style: TextStyle(fontSize: 20.0),),
      ),
      Container(
        height: 40,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        ),
        child: buildNextExercisesWidget(),
        ),
      Container(
        alignment: Alignment.topRight,
        padding: EdgeInsets.all(8),
        child: buildTotalTimeWidget(),
      ),
    ],
  );

  Widget buildCurrentExerciseWidget() {
    Widget currentExerciseGifButton = createGifButton(currentExerciseString , currentExerciseGif, 24);
        var currentExerciseText = Text(
                currentExerciseString,
                maxLines: 1,
                style: TextStyle(
                  fontSize: exerciseFontSize, 
                  fontWeight: FontWeight.w300, 
                  color: mainTextColor,
                  height: 0.9),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.left,
          );
          return Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(child: FittedBox(fit:BoxFit.scaleDown,child: currentExerciseText)),
                SizedBox.fromSize(size: Size(12, 12),),
                currentExerciseGifButton,],);
  }

  Widget buildCurrentTimeWidget() {
    return Text(
        blockRemainingTimeString,
        style: TextStyle(
          height: 0.95,
          fontSize: timeFontSize, 
          color: Themes.normal.colorScheme.primary,)
    );
  }

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

  String get currentExerciseString {
    if (this.widget._countdownElementList.length == 0) return '';
    String s = this.widget._countdownElementList[this.widget._currentCountdownElementIndex()].name;
    return s;
  }

  String get currentExerciseGif {
    if (this.widget._countdownElementList.length == 0) return '';
    return this.widget._countdownElementList[this.widget._currentCountdownElementIndex()].gifUrl;
  }

  Widget finishedMessageText() {
    return Container(child: Text(
        'FINISHED',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40.0, color: mainTextColor),
      ));
  }

  Widget afterMessageText() {
    return Text(
            'AFTER',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, color: fadedTextColor),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
      );
  }

  Widget createGifButton(String title, String gifUrl, double size) {
    return gifUrl == null || gifUrl == '' ? SizedBox(width: 1, height: 1) : GestureDetector(
      onTap: () {showGifDialog(title, gifUrl);}, 
      child: Icon(Icons.ondemand_video, size: size, color: Themes.normal.colorScheme.secondary,));
  }

  void showGifDialog(String title, String gifUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        AlertDialog(
          title: Text(title, style: TextStyle(color: mainTextColor,),),
          backgroundColor: Themes.normal.colorScheme.primary,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[GifHandler.createGifImage(gifUrl, width: 400)],
          ),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {Navigator.of(context).pop();},
            ),
          ],
        )
    );
  }

  Widget buildNextExercisesWidget() {
    List<String> listElements = this.widget._countdownElementList.sublist(min(this.widget._currentCountdownElementIndex()+1,this.widget._countdownElementList.length)).map((e) => e.name.substring(0, e.name.length < 20 ? e.name.length : 20) + ' (' + DurationFormatter.format(e.totalTime) + ')').toList();
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: listElements.asMap().entries.map((entry) {
        String e = entry.value;
        bool shouldTrailing = entry.key != listElements.length - 1;
        String text = shouldTrailing ? e + ' | ' : e;
        return Card(
          margin: EdgeInsets.all(0),
          color: Colors.transparent,
          child: Text(text, style: TextStyle(color: fadedTextColor, fontSize: exerciseFontSize, height: 1), textAlign: TextAlign.center),
        );
      }
      ).toList(),
  );
  }

  Widget createNextExercisesList() {
    List<String> listElements = this.widget._countdownElementList.sublist(min(this.widget._currentCountdownElementIndex()+1,this.widget._countdownElementList.length)).map((e) => e.name.substring(0, e.name.length < 20 ? e.name.length : 20) + ' (' + DurationFormatter.format(e.totalTime) + ')').toList();
        return Container(
            height: 80,
            width: 300,
            margin: EdgeInsets.only(bottom: 20.0),
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                  stops: [0.8, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: ListView(
              padding: EdgeInsets.zero,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: listElements.asMap().entries.map((entry) {
                String e = entry.value;
                return Card(
                  margin: EdgeInsets.all(2),
                  color: Colors.transparent,
                  child: Text(e, style: TextStyle(color: fadedTextColor, fontSize: 14), textAlign: TextAlign.center),
                );
              }
              ).toList(),
          )
          )
        );
    }
}