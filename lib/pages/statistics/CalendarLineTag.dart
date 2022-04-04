import 'package:flutter/material.dart';

class CalendarLineTag extends StatelessWidget {
  const CalendarLineTag({
    Key key,
    @required this.message,
    @required this.index,
  }) : super(key: key);

  final String message;
  final int index;

  static List<Color> options = [
    Colors.red[700],
    Colors.blue[700],
    Colors.orange[700],
    Colors.green[700],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 10),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
          color: options[index % options.length],
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Text(
        message,
        overflow: TextOverflow.clip,
        style: TextStyle(color: Colors.white, fontSize: 8),
      ),
    );
  }
}
