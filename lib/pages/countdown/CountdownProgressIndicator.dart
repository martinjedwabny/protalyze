import 'package:flutter/material.dart';
import 'package:protalyze/config/Palette.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/countdown/CustomTimerPainter.dart';

class CountdownProgressIndicator extends StatefulWidget {
  const CountdownProgressIndicator(this._controller);
  final AnimationController _controller;
  @override
  _CountdownProgressIndicatorState createState() => _CountdownProgressIndicatorState();
}

class _CountdownProgressIndicatorState extends State<CountdownProgressIndicator> {

  final double heightLimit = 200.0;
  final double topMarginSmallLayout = 110.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if(constraints.maxHeight > heightLimit) {
        return buildBigLayoutIndicator();
      } else {
        return buildSmallLayoutIndicator();
      }
    });
  }

  Widget buildSmallLayoutIndicator() {
    return Container(
      padding: EdgeInsets.only(top: topMarginSmallLayout, left: 40.0, right: 40.0),
      width: double.infinity,
      child: Slider(
        value: this.widget._controller.value, 
        onChanged: (value) {}),
    );
  }

  Widget buildBigLayoutIndicator() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedBuilder(
        animation: this.widget._controller,
        builder: (BuildContext context, Widget child) {
          return CustomPaint(
            size: Size.infinite,
              painter: CustomTimerPainter(
                animation: this.widget._controller,
                backgroundColor: Palette.orange.withAlpha(150),
                color1: Themes.normal.colorScheme.secondary,
                color2: Colors.red,
          ));
        },
      ),
    );
  }
}