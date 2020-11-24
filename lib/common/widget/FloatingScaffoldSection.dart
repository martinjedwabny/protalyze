import 'package:flutter/material.dart';

class FloatingScaffoldSection extends StatelessWidget {
  const FloatingScaffoldSection({
    Key key,
    @required this.child,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(Radius.circular(16.0))
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}