import 'package:Protalyze/config/Palette.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:Protalyze/persistance/PastWorkoutDataManager.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:just_audio/just_audio.dart';

class CountDownPage extends StatefulWidget {
  final Workout workout;
  CountDownPage(Workout original) : workout = Workout.copy(original);
  @override
  _CountDownPageState createState() => _CountDownPageState();
}

enum CountdownStatus {
  PREPARE,
  REST,
  WORK,
  FINISHED
}

class _CountDownPageState extends State<CountDownPage> with TickerProviderStateMixin {
  int soundId;
  AnimationController controller;
  int remainingSeconds = 10000000;
  List<ExerciseBlock> exercises;
  ExerciseBlock currentExercise;
  ExerciseBlock nextExercise;
  CountdownStatus status = CountdownStatus.PREPARE;
  final player = AudioPlayer();

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String get statusString {
    if (this.status == CountdownStatus.PREPARE)
      return 'PREPARE';
    if (this.status == CountdownStatus.REST)
      return 'REST';
    if (this.status == CountdownStatus.WORK)
      return 'WORK';
    return 'FINISHED';
  }

  String get currentExerciseString {
    if (this.currentExercise == null)
      return '';
    return '${getExerciseString(this.currentExercise)}';
  }

  List<Text> get exercisesTexts {
    return [
      Text(
        'NOW',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 24.0,
            color: Colors.white),
      ),
      Text(
        currentExerciseString,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
            color: Colors.white),
      ),
      Text(
        'NEXT',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 24.0,
            color: Colors.white),
      ),
      Text(
        nextExerciseString,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
            color: Colors.white),
      ),
    ];
  }

  String getExerciseString(ExerciseBlock block) {
    String ans = block.exercise.name;
    if (block.weight != null)
      ans += ', ' + block.weight.toString();
    if (block.minReps != null && block.maxReps != null)
      ans += ', ' + block.minReps.toString() + '-' + block.maxReps.toString() + ' reps';
    if (block.minReps != null && block.maxReps == null)
      ans += ', ' +  block.minReps.toString() + ' min reps';
    if (block.minReps == null && block.maxReps != null)
      ans += ', ' +  block.maxReps.toString() + ' max reps';
    return ans;
  }

  String get nextExerciseString {
    if (this.nextExercise == null)
      return '';
    return '${getExerciseString(this.nextExercise)}';
  }

  void updateExerciseList(){
    if (this.status == CountdownStatus.PREPARE) {
      this.status = CountdownStatus.WORK;
      this.currentExercise = this.exercises.length > 0 ? this.exercises[0] : null;
      this.nextExercise = this.exercises.length > 1 ? this.exercises[1] : null;
      this.controller.duration = this.currentExercise.performingTime;
      this.controller.reset();
      this.controller.reverse(from: controller.value == 0 ? 1.0 : this.controller.value);
    } else if (this.status == CountdownStatus.WORK) {
      this.status = CountdownStatus.REST;
      this.controller.duration = this.currentExercise.restTime;
      this.controller.reset();
      this.controller.reverse(from: controller.value == 0 ? 1.0 : this.controller.value);
    } else if (this.status == CountdownStatus.REST) {
      this.exercises.removeAt(0);
      this.currentExercise = this.exercises.length > 0 ? this.exercises[0] : null;
      this.nextExercise = this.exercises.length > 1 ? this.exercises[1] : null;
      if (this.exercises.isEmpty) {
        this.status = CountdownStatus.FINISHED;
      } else {
        this.status = CountdownStatus.WORK;
        this.controller.duration = this.currentExercise.performingTime;
        this.controller.reset();
        this.controller.reverse(from: controller.value == 0 ? 1.0 : this.controller.value);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    player.setUrl('https://bigsoundbank.com/UPLOAD/mp3/1616.mp3');
    this.exercises = this.widget.workout.exercises;
    this.currentExercise = this.exercises.length > 0 ? this.exercises[0] : null;
    this.nextExercise = this.exercises.length > 1 ? this.exercises[1] : null;
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
      value: 1.0
    );
    controller.addListener(() {
      int secs = (controller.duration * controller.value).inSeconds;
      if (secs != remainingSeconds) {
        remainingSeconds = secs;
        if (secs == 5 || secs == 0) {
          playBeepSound();
        }
        if (secs == 0) {
          updateExerciseList();
        }
      }
    });
  }

  void playBeepSound(){
    player.seek(Duration(seconds: 0));
    player.play();
    // SystemSound.play(SystemSoundType.click);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Palette.darkBlueColor,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    color: Palette.yellowColor,
                    height:
                    controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Container(alignment: Alignment.topCenter, child: 
                  Text(
                    statusString,
                    style: TextStyle(
                        fontSize: 60.0,
                        color: Colors.white),
                  ),),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                        animation: controller,
                                        backgroundColor: Palette.darkBlueColor,
                                        color: themeData.indicatorColor,
                                      )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 70, right: 70), 
                                      child: 
                                      Column(children: exercisesTexts,),
                                      ),
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 90.0,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return FloatingActionButton.extended(
                                heroTag: 'playpausetimer',
                                onPressed: () {
                                  if (this.status == CountdownStatus.FINISHED)
                                    return;
                                  if (controller.isAnimating)
                                    controller.stop();
                                  else {
                                    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
                                  }
                                  setState((){});
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                label: Text(
                                    controller.isAnimating ? "Pause" : "Play"));
                          }),
                      FloatingActionButton.extended(
                        heroTag: 'saveworkouttimer',
                        onPressed: () {
                          PastWorkout toSave = PastWorkout(this.widget.workout, DateTime.now());
                          PastWorkoutDataManager.addPastWorkout(toSave).then((value) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Workout registered!'),
                            ));
                          });
                        },
                        icon: Icon(Icons.save),
                        label: Text("Save")
                      ),
                      FloatingActionButton.extended(
                        heroTag: 'exittimer',
                        onPressed: () {
                          Navigator.pop(context, () {});
                        },
                        icon: Icon(Icons.exit_to_app),
                        label: Text("Exit")
                      ),
                      ],),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}