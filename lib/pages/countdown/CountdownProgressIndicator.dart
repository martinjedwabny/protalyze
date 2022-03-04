import 'package:flutter/material.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/countdown/CustomTimerPainter.dart';

class CountdownProgressIndicator extends StatefulWidget {
  const CountdownProgressIndicator(this._controller);
  final AnimationController _controller;
  @override
  _CountdownProgressIndicatorState createState() => _CountdownProgressIndicatorState();
}

class _CountdownProgressIndicatorState extends State<CountdownProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedBuilder(
        animation: this.widget._controller,
        builder: (BuildContext context, Widget child) {
          return CustomPaint(
            size: Size.infinite,
              painter: CustomTimerPainter(
                animation: this.widget._controller,
                backgroundColor: Colors.grey[700],
                color1: Themes.normal.colorScheme.secondary,
                color2: Colors.red,
          ));
        },
      ),
    );
  }
}