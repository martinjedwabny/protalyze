import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/bloc/TimerNotifier.dart';
import 'package:Protalyze/config/Palette.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class CountDownPage extends StatefulWidget {
  final Workout workout;
  List<ExerciseBlock> exerciseBlocks;
  CountDownPage(Workout workout) : this.workout = workout {
    this.exerciseBlocks = [];
    for (ExerciseBlock block in workout.exercises) {
      if (block.sets == null)
        this.exerciseBlocks.add(block);
      for (int i = 1; i <= block.sets; i++)
        this.exerciseBlocks.add(block);
    }
  }
  @override
  _CountDownPageState createState() => _CountDownPageState();
}

enum CountdownStatus { PREPARE, REST, WORK, FINISHED }

class _CountDownPageState extends State<CountDownPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Iterator<ExerciseBlock> exerciseIterator;
  ExerciseBlock currentExercise;
  ExerciseBlock nextExercise;
  CountdownStatus status = CountdownStatus.PREPARE;
  TimerNotifier blockTimer;
  Duration blockRemainingTime;
  Duration totalRemainingTime;

  Future<AudioPlayer> playBeepSound() async {
    AudioCache cache = new AudioCache();
    return await cache.play("beep.mp3");
  }

  @override
  void dispose() {
    controller.dispose();
    try {
      Wakelock.disable();
    } catch (e) {}
    super.dispose();
  }

  void initializeTimer() {
    this.blockRemainingTime = Duration(seconds: 10);
    int totalRemainingSeconds = 10;
    for (ExerciseBlock block in this.widget.exerciseBlocks)
      totalRemainingSeconds +=
          block.performingTime.inSeconds + block.restTime.inSeconds;
    this.totalRemainingTime = Duration(seconds: totalRemainingSeconds);
    blockTimer = TimerNotifier(Duration(seconds: 10));
    blockTimer.addListener(() {
      this.blockRemainingTime -= Duration(seconds: 1);
      this.totalRemainingTime -= Duration(seconds: 1);
      int time = blockRemainingTime.inSeconds;
      if (time == 5 || time == 0) {
        playBeepSound();
      }
      if (time == 0) {
        updateExerciseList();
      }
    });
  }

  void startTimer() {
    this.controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    this.blockTimer.start();
  }

  void stopTimer() {
    this.controller.stop();
    this.blockTimer.pause();
  }

  @override
  void initState() {
    super.initState();
    try {
      Wakelock.enable();
    } catch (e) {}
    this.exerciseIterator = this.widget.exerciseBlocks.iterator;
    this.exerciseIterator.moveNext();
    this.currentExercise = this.exerciseIterator.current;
    this.exerciseIterator.moveNext();
    this.nextExercise = this.exerciseIterator.current;
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 10), value: 1.0);
    initializeTimer();
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
                  child: Container(
                    color: Palette.yellowColor,
                    height:
                        controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    statusString,
                    style: TextStyle(fontSize: 60.0, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 80.0),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 70, right: 70),
                                        child: Column(
                                          children: exercisesTexts,
                                        ),
                                      ),
                                      Text(
                                        blockRemainingTimeString,
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
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Remaining time: ' + totalRemainingTimeString,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedBuilder(
                                animation: controller,
                                builder: (context, child) {
                                  return FloatingActionButton.extended(
                                      heroTag: 'playpausetimer',
                                      onPressed: () {
                                        if (this.status ==
                                            CountdownStatus.FINISHED) return;
                                        if (controller.isAnimating)
                                          stopTimer();
                                        else
                                          startTimer();
                                      },
                                      icon: Icon(controller.isAnimating
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                      label: Text(controller.isAnimating
                                          ? "Pause"
                                          : "Play"));
                                }),
                            FloatingActionButton.extended(
                                heroTag: 'saveworkouttimer',
                                onPressed: () {
                                  PastWorkout toSave = PastWorkout(
                                      this.widget.workout, DateTime.now());
                                  Provider.of<PastWorkoutNotifier>(context,
                                          listen: false)
                                      .addPastWorkout(toSave)
                                      .then((v) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Workout registered!'),
                                    ));
                                  });
                                },
                                icon: Icon(Icons.save),
                                label: Text("Save")),
                            FloatingActionButton.extended(
                                heroTag: 'exittimer',
                                onPressed: () {
                                  Navigator.pop(context, () {});
                                },
                                icon: Icon(Icons.exit_to_app),
                                label: Text("Exit")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  String get blockRemainingTimeString {
    Duration duration = this.blockRemainingTime;
    if (duration.inHours > 0)
      return '${duration.inHours}:${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String get totalRemainingTimeString {
    Duration duration = this.totalRemainingTime;
    if (duration.inHours > 0)
      return '${duration.inHours}:${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String get nextExerciseString {
    if (this.nextExercise == null) return '';
    return '${getExerciseString(this.nextExercise)}';
  }

  String get currentExerciseString {
    if (this.currentExercise == null) return '';
    return '${getExerciseString(this.currentExercise)}';
  }

  String get statusString {
    if (this.status == CountdownStatus.PREPARE) return 'PREPARE';
    if (this.status == CountdownStatus.REST) return 'REST';
    if (this.status == CountdownStatus.WORK) return 'WORK';
    return 'FINISHED';
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

  String getExerciseString(ExerciseBlock block) {
    String ans = block.exercise.name;
    if (block.weight != null) ans += ', ' + block.weight.toString();
    if (block.minReps != null && block.maxReps != null)
      ans += ', ' +
          block.minReps.toString() +
          '-' +
          block.maxReps.toString() +
          ' reps';
    if (block.minReps != null && block.maxReps == null)
      ans += ', ' + block.minReps.toString() + ' min reps';
    if (block.minReps == null && block.maxReps != null)
      ans += ', ' + block.maxReps.toString() + ' max reps';
    return ans;
  }

  void updateExerciseList() {
    if (this.status == CountdownStatus.PREPARE) {
      this.status = CountdownStatus.WORK;
      this.controller.duration = this.currentExercise.performingTime;
      this.controller.reset();
      this
          .controller
          .reverse(from: controller.value == 0 ? 1.0 : this.controller.value);
    } else if (this.status == CountdownStatus.WORK) {
      this.status = CountdownStatus.REST;
      this.controller.duration = this.currentExercise.restTime;
      this.currentExercise = this.exerciseIterator.current;
      this.exerciseIterator.moveNext();
      this.nextExercise = this.exerciseIterator.current;
      this.controller.reset();
      this
          .controller
          .reverse(from: controller.value == 0 ? 1.0 : this.controller.value);
    } else if (this.status == CountdownStatus.REST) {
      if (this.currentExercise == null && this.nextExercise == null) {
        this.status = CountdownStatus.FINISHED;
      } else {
        this.status = CountdownStatus.WORK;
        this.controller.duration = this.currentExercise.performingTime;
        this.controller.reset();
        this
            .controller
            .reverse(from: controller.value == 0 ? 1.0 : this.controller.value);
      }
    }
    if (this.status == CountdownStatus.FINISHED) {
      this.blockTimer.dispose();
    } else {
      this.blockTimer = TimerNotifier(this.controller.duration);
      this.blockRemainingTime = this.controller.duration;
    }
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
