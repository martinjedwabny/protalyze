import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:protalyze/config/Themes.dart';

class CountdownControls extends StatefulWidget {
  final AnimationController controller;
  final Function backwardCallback;
  final Function forwardCallback;
  final Function playPauseCallback;
  final Function minusCallback;
  final Function plusCallback;
  final Function countdownFinished;
  final Function isPause;

  const CountdownControls(this.controller, this.backwardCallback, this.forwardCallback, this.playPauseCallback, this.minusCallback, this.plusCallback, this.countdownFinished, this.isPause);

  @override
  _CountdownControlsState createState() => _CountdownControlsState();
}

class _CountdownControlsState extends State<CountdownControls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 30,height: 30,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => this.widget.backwardCallback(), 
              icon: LineIcon.backward(color: Colors.white, size: 40,)
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: AnimatedBuilder(
                animation: this.widget.controller,
                builder: (context, child) {
                  return TextButton(
                      onPressed: () {
                        this.widget.playPauseCallback();
                        setState(() {});
                      },
                      child: Icon(
                        this.widget.countdownFinished()? LineIcons.check : !this.widget.isPause() ? LineIcons.pause : LineIcons.play,
                        size: 90,
                        color: Colors.white,
                      )
                    );
              }),
            ),
            IconButton(
              onPressed: () => this.widget.forwardCallback(), 
              icon: LineIcon.forward(color: Colors.white, size: 40,)
            ),
          ],),
          SizedBox(width: 4,height: 4,),
          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min,
          children: [
            buildProgressTextButton('-5s', () => this.widget.minusCallback()),
            buildProgressTextButton('+5s', () => this.widget.plusCallback()),
          ],),
      ]
      );
  }

  Widget buildProgressTextButton(String text, Function callback){
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Themes.normal.colorScheme.primary,
        padding: EdgeInsets.all(8),
        side: BorderSide(width: 2.0, color: Colors.white),
      ),
      onPressed: () { callback.call(); }, 
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),),
    );
  }
}