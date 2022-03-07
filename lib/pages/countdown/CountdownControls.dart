import 'package:flutter/material.dart';
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

  final Icon backButton = Icon(Icons.fast_rewind, color: Colors.white, size: 40,);
  final Icon forwardButton = Icon(Icons.fast_forward, color: Colors.white, size: 40,);
  final Icon playButton = Icon(Icons.play_arrow,color: Colors.white, size: 90,);
  final Icon pauseButton = Icon(Icons.pause,color: Colors.white, size: 90,);
  final Icon doneButton = Icon(Icons.done,color: Colors.white, size: 90,);

  final double topMargin = 40;
  final double interRowSpacing = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 1,height: topMargin,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => this.widget.backwardCallback(), 
              icon: backButton,
            ),
            AnimatedBuilder(
              animation: this.widget.controller,
              builder: (context, child) {
                return TextButton(
                    onPressed: () {
                      this.widget.playPauseCallback();
                      setState(() {});
                    },
                    child: this.widget.countdownFinished()? doneButton : !this.widget.isPause() ? pauseButton : playButton,
                  );
            }),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => this.widget.forwardCallback(), 
              icon: forwardButton,
            ),
          ],),
          SizedBox(width: 1,height: interRowSpacing,),
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
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(8),
        side: BorderSide(width: 2.0, color: Colors.white),
      ),
      onPressed: () { callback.call(); }, 
      child: Text(text, style: TextStyle(color: Themes.normal.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700),),
    );
  }
}