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

  final Icon backIcon = Icon(Icons.fast_rewind, color: Colors.white, size: 36,);
  final Icon forwardIcon = Icon(Icons.fast_forward, color: Colors.white, size: 36,);
  final Icon playIcon = Icon(Icons.play_arrow,color: Colors.white, size: 80,);
  final Icon pauseIcon = Icon(Icons.pause,color: Colors.white, size: 80,);
  final Icon doneIcon = Icon(Icons.done,color: Colors.white, size: 80,);

  final double topMargin = 40;
  final double interRowSpacing = 10;
  final double heightLimit = 200.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if(constraints.maxHeight > heightLimit) {
        return buildBigLayoutControls();
      } else {
        return buildSmallLayoutControls();
      }
    });
  }

  Widget backButton() => IconButton(
    padding: EdgeInsets.zero,
    onPressed: () => this.widget.backwardCallback(), 
    icon: backIcon,
  );

  Widget playButton() => AnimatedBuilder(
    animation: this.widget.controller,
    builder: (context, child) {
      return TextButton(
          onPressed: () {
            this.widget.playPauseCallback();
            setState(() {});
          },
          child: this.widget.countdownFinished()? doneIcon : !this.widget.isPause() ? pauseIcon : playIcon,
        );
  });

  Widget forwardButton() => IconButton(
    padding: EdgeInsets.zero,
    onPressed: () => this.widget.forwardCallback(), 
    icon: forwardIcon,
  );

  Widget minusButton() => buildProgressTextButton('-5s', () => this.widget.minusCallback());

  Widget plusButton() => buildProgressTextButton('+5s', () => this.widget.plusCallback());

  Widget buildSmallLayoutControls() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        minusButton(),
        backButton(),
        playButton(),
        forwardButton(),
        plusButton(),
      ],
    );
  }

  Widget buildBigLayoutControls() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 1,height: topMargin,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            backButton(),
            playButton(),
            forwardButton(),
          ],),
          SizedBox(width: 1,height: interRowSpacing,),
          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min,
          children: [
            minusButton(),
            plusButton(),
          ],),
      ]
      );
  }

  Widget buildProgressTextButton(String text, Function callback){
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Themes.normal.colorScheme.primary,
        padding: EdgeInsets.all(14),
        side: BorderSide(width: 2.0, color: Colors.white),
      ),
      onPressed: () { callback.call(); }, 
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),),
    );
  }
}