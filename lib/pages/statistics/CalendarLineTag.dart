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
      color: options[index % options.length],
      constraints: BoxConstraints.expand(height: 10),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        message,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: 8),
      ),
    );
  }
}
