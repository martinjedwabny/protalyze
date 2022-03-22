import 'package:flutter/material.dart';

class RoundedBoxContainer extends StatelessWidget {
  const RoundedBoxContainer(this.child,
      {this.radius = 20.0, this.backgroundColor = Colors.white});

  final Widget child;
  final double radius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
