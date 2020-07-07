import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHeaderItem extends StatelessWidget {
  final DateTime date;
  DateHeaderItem(this.date);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.grey[200],
      child: Center(child:
        Text(
          DateFormat("EEE, MMM d").format(date),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}