import 'package:flutter/material.dart';
import 'package:protalyze/config/Palette.dart';

class CountdownControls extends StatefulWidget {
  final AnimationController controller;
  final Function backwardCallback;
  final Function forwardCallback;
  final Function playPauseCallback;
  final Function minusCallback;
  final Function plusCallback;
  final Function countdownFinished;
  final Function isPause;

  const CountdownControls(
      this.controller,
      this.backwardCallback,
      this.forwardCallback,
      this.playPauseCallback,
      this.minusCallback,
      this.plusCallback,
      this.countdownFinished,
      this.isPause);

  @override
  _CountdownControlsState createState() => _CountdownControlsState();
}

class _CountdownControlsState extends State<CountdownControls> {
  final Icon backIcon = Icon(
    Icons.fast_rewind,
    color: Palette.darkGray.withAlpha(200),
    size: 40,
  );
  final Icon forwardIcon = Icon(
    Icons.fast_forward,
    color: Palette.darkGray.withAlpha(200),
    size: 40,
  );
  final Icon playIcon = Icon(
    Icons.play_arrow,
    color: Palette.darkGray.withAlpha(200),
    size: 70,
  );
  final Icon pauseIcon = Icon(
    Icons.pause,
    color: Palette.darkGray.withAlpha(200),
    size: 70,
  );
  final Icon doneIcon = Icon(
    Icons.done,
    color: Palette.darkGray.withAlpha(200),
    size: 50,
  );

  final textButtonColor = Palette.darkGray.withAlpha(200);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return buildSmallLayoutControls();
    });
  }

  Widget backButton() => IconButton(
        padding: EdgeInsets.zero,
        onPressed: this.widget.countdownFinished()
            ? null
            : () => this.widget.backwardCallback(),
        icon: backIcon,
      );

  Widget playButton() => AnimatedBuilder(
      animation: this.widget.controller,
      builder: (context, child) {
        return TextButton(
          onPressed: this.widget.countdownFinished()
              ? null
              : () {
                  this.widget.playPauseCallback();
                  setState(() {});
                },
          child: this.widget.countdownFinished()
              ? doneIcon
              : !this.widget.isPause()
                  ? pauseIcon
                  : playIcon,
        );
      });

  Widget forwardButton() => IconButton(
        padding: EdgeInsets.zero,
        onPressed: this.widget.countdownFinished()
            ? null
            : () => this.widget.forwardCallback(),
        icon: forwardIcon,
      );

  Widget minusButton() => buildProgressTextButton(
      '-5s',
      this.widget.countdownFinished()
          ? null
          : () => this.widget.minusCallback());

  Widget plusButton() => buildProgressTextButton(
      '+5s',
      this.widget.countdownFinished()
          ? null
          : () => this.widget.plusCallback());

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

  Widget buildProgressTextButton(String text, Function callback) {
    return TextButton(
      onPressed: () {
        callback.call();
      },
      child: Text(
        text,
        style: TextStyle(
            color: textButtonColor, fontSize: 16, fontWeight: FontWeight.w900),
      ),
    );
  }
}
