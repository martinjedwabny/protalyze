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

  @override
  Widget build(BuildContext context) {
    if (isCountdownFinished()) {
      return finishedMessageText();
    } else {
      var currentExerciseTextContainer = currentExerciseText();
      if (this.widget._countdownElementList.length == 1)
        return Column(children: [currentExerciseTextContainer]);
      var nextExercisesTitle = afterMessageText();
      var nextExercisesList = createNextExercisesList();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            currentExerciseTextContainer,
            nextExercisesTitle,
            nextExercisesList,
        ]
      );
    }
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

  Widget currentExerciseText(){
    Widget currentExerciseGifButton = createGifButton(currentExerciseString , currentExerciseGif, 30);
    var currentExerciseText = Text(
            currentExerciseString,
            style: TextStyle(
              fontSize: 40.0, 
              fontWeight: FontWeight.w300, 
              color: mainTextColor,
              height: 0.8),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
      );
      return Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Container(child: currentExerciseText)),
            SizedBox.fromSize(size: Size(12, 12),),
            currentExerciseGifButton,],);
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