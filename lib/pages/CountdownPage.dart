import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/config/Palette.dart';
import 'package:Protalyze/domain/CountdownElement.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/misc/DurationFormatter.dart';
import 'package:Protalyze/misc/ScreenPersist.dart';
import 'package:Protalyze/widgets/SingleMessageConfirmationDialog.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class CountDownPage extends StatefulWidget {
  final Workout _workout;
  CountDownPage(this._workout);
  @override
  _CountDownPageState createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> with TickerProviderStateMixin {
  AnimationController _controller;
  bool _isPause = true;
  Duration _totalTime;
  List<CountdownElement> _countdownElements;
  final int _prepareTime = 3;
  final Color _buttonsColor = Palette.orangeColor, _circleColor = Palette.orangeColor;

  Future<AudioPlayer> playBeepSound() async => await (new AudioCache()).play("beep.mp3");

  @override
  void dispose() {
    ScreenPersist.disable();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ScreenPersist.enable();
    this._controller = AnimationController(vsync: this, value: 1.0);
    this._controller.addStatusListener((status) => animationStatusChanged(status));
    initializeCountdownElements();
  }

  void animationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      playBeepSound();
      stepToNextExercise();
    }
  }

  void stepToNextExercise() {
    if (this._countdownElements.isEmpty) return;
    this._totalTime -= this._countdownElements[0].totalTime;
    this._countdownElements.removeAt(0);
    if (this._countdownElements.isEmpty) return;
    this._controller.duration = this._countdownElements[0].totalTime;
    this._controller.value = 1.0;
    this._controller.reverse();
  }

  void initializeCountdownElements(){
    // Set initial duration / prepare time to this._prepareTime seconds
    this._controller.duration = Duration(seconds: this._prepareTime);
    this._countdownElements = [new CountdownElement('Prepare', new Duration(seconds: this._prepareTime))];
    this._totalTime = Duration(seconds: this._prepareTime);
    // Add perform and rest times for each block
    for (ExerciseBlock block in this.widget._workout.exercises) {
      int sets = block.sets == null ? 1 : block.sets;
      for (int i = 0; i < sets; i++){
        if (block.performingTime != null && block.performingTime.inSeconds > 0) {
          this._countdownElements.add(new CountdownElement(block.toString(), block.performingTime));
          this._totalTime += block.performingTime;
        }
        if (block == this.widget._workout.exercises.last && i == (sets - 1))
          continue;
        if (block.restTime != null && block.restTime.inSeconds > 0) {
          this._countdownElements.add(new CountdownElement('Rest', block.restTime));
          this._totalTime += block.restTime;
        }
      }
    }
  }

  bool countdownFinished(){
    return this._totalTime.inSeconds == 0;
  }

  void togglePlayPause(){
    if (this.countdownFinished()) return;
    if (this._isPause) {
      this._controller.reverse(); //play in reverse mode
    } else {
      this._controller.stop();
    }
    this._isPause = !this._isPause;
  }

  Widget buildCurrentTimeWidget() {
    var currentTimeFontSize = 80.0;
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 20.0),
      child: Text(
        blockRemainingTimeString,
        style: TextStyle(fontSize: currentTimeFontSize, color: Colors.white),
      ),
    );
  }

  Widget buildExercisesWidget(){
    return Align(alignment: FractionalOffset.center,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 70, right: 70),
          child: Container(
            height: 140.0,
            child: Column( children: exercisesTexts, ),
            )
          ),
        ],
      ),
    );
  }

  Widget buildProgressCircle(){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(64.0),
        child: Align(
          alignment: FractionalOffset.center,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                      painter: CustomTimerPainter(
                        animation: _controller,
                        color: this._circleColor,
                    )
                  ),
                ),
                Center(child: 
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return FlatButton(
                          onPressed: () {
                            togglePlayPause();
                            setState(() {});
                          },
                          child: Text(this.countdownFinished()? 'Done' : !this._isPause ? "Pause" : "Play", 
                            style: TextStyle(fontSize: 36.0, color: this._buttonsColor),)
                          );
                    }),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget buildBottomButtons(){
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              onPressed: () {
                PastWorkout toSave = PastWorkout(
                    this.widget._workout, DateTime.now());
                Provider.of<PastWorkoutNotifier>(context,
                        listen: false)
                    .addPastWorkout(toSave)
                    .then((v) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Workout registered!'),
                  ));
                });
              },
              child: Text("Save", style: TextStyle(fontSize: 24.0, color: this._buttonsColor))
            ),
            Column(
              children: [
                SizedBox(
                  height: 36.0,
                  child: 
                    Text(totalRemainingTimeString,
                    style: TextStyle(
                      fontSize: 30.0,
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
            FlatButton(
              onPressed: () {
                handleExitButton();
              },
              child: Text("Exit", style: TextStyle(fontSize: 24.0, color: this._buttonsColor))
            ),
          ],
        ),
      )
    );
  }

  void handleExitButton(){
    if (this.countdownFinished())
      Navigator.pop(context, () {});
    else
      showDialog(
        context: context,
        builder: (_) {
          return SingleMessageConfirmationDialog("Workout not finished", "Do you really want to exit?", 
          (){Navigator.pop(context, () {});}, 
          (){});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget._workout.name),
      ),
      backgroundColor: Palette.darkBlueColor,
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              children: <Widget>[
                buildCurrentTimeWidget(),
                buildExercisesWidget(),
                buildProgressCircle(),
                buildBottomButtons(),
              ],
            );
          }
      )
    );
  }

  String get blockRemainingTimeString {
    return DurationFormatter.format(_controller.duration * _controller.value);
  }

  String get totalRemainingTimeString {
    if (this._countdownElements.isEmpty)
      return DurationFormatter.format(this._totalTime);
    return DurationFormatter.format(this._totalTime - _controller.duration * (1.0 - _controller.value));
  }

  String get nextExerciseString {
    if (this._countdownElements.length < 2) return '';
    return this._countdownElements[1].name;
  }

  String get currentExerciseString {
    if (this._countdownElements.length == 0) return '';
    return this._countdownElements[0].name;
  }

  List<Text> get exercisesTexts {
    List<Text> texts = new List<Text>();
    if (this.currentExerciseString.length > 0) {
      texts.add(Text(
        'NOW',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      ));
      texts.add(Text(
        currentExerciseString,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w300, color: Colors.white),
      ));
    } else {
      texts.add(Text(
        'FINISHED',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      ));
    }
    if (this.nextExerciseString.length > 0) {
      texts.add(Text(
        'AFTER',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, color: Colors.white70),
      ));
      texts.add(Text(
        nextExerciseString,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w300, color: Colors.white70),
      ));
    }
    return texts;
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = Color.fromRGBO(108, 86, 52, 1.0);
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color;
  }
}
