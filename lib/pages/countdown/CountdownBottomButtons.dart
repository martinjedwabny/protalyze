import 'package:flutter/material.dart';

class CountdownBottomButtons extends StatefulWidget {
  final Function totalRemainingTimeString;
  final Function handleSaveWorkout;
  final Function handleExit;

  const CountdownBottomButtons(this.totalRemainingTimeString, this.handleSaveWorkout, this.handleExit);
  @override
  _CountdownBottomButtonsState createState() => _CountdownBottomButtonsState();
}

class _CountdownBottomButtonsState extends State<CountdownBottomButtons> {
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
              child: Text("Save", style: TextStyle(fontSize: 24.0, color: Colors.white))
            ),
            Column(
              children: [
                SizedBox(
                  height: 40.0,
                  child: 
                    Text(totalRemainingTimeString,
                    style: TextStyle(
                      fontSize: 36.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Text('Total',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ]
            ),
            TextButton(
              onPressed: () {
                this.widget.handleExit();
              },
              child: Text("Exit", style: TextStyle(fontSize: 24.0, color: Colors.white))
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