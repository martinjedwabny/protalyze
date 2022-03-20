import 'package:flutter/material.dart';
import 'package:protalyze/config/Themes.dart';

class CountdownBottomButtons extends StatefulWidget {
  final Function totalRemainingTimeString;
  final Function handleSaveWorkout;
  final Function handleExit;

  const CountdownBottomButtons(this.totalRemainingTimeString, this.handleSaveWorkout, this.handleExit);
  @override
  _CountdownBottomButtonsState createState() => _CountdownBottomButtonsState();
}

class _CountdownBottomButtonsState extends State<CountdownBottomButtons> {
  final Color buttonsColor = Themes.normal.colorScheme.primary;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left:8.0,right:8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                this.widget.handleSaveWorkout();
              },
              child: Text("Save", style: TextStyle(fontSize: 24.0, color: buttonsColor))
            ),
            Column(
              children: [
                SizedBox(
                  height: 42.0,
                  child: 
                    Text(totalRemainingTimeString,
                    style: TextStyle(
                      fontSize: 36.0,
                      color: buttonsColor,
                    ),
                  ),
                ),
                Text('Total',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: buttonsColor,
                  ),
                ),
              ]
            ),
            TextButton(
              onPressed: () {
                this.widget.handleExit();
              },
              child: Text("Exit", style: TextStyle(fontSize: 24.0, color: buttonsColor))
            ),
          ],
        ),
      )
    );
  }

  String get totalRemainingTimeString {
    return this.widget.totalRemainingTimeString();
  }
}