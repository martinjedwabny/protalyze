import 'package:Protalyze/provider/PastWorkoutNotifier.dart';
import 'package:Protalyze/config/Palette.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/pages/countdown/CountdownElement.dart';
import 'package:Protalyze/common/domain/PastWorkout.dart';
import 'package:Protalyze/common/domain/Workout.dart';
import 'package:Protalyze/common/utils/DurationFormatter.dart';
import 'package:Protalyze/common/utils/ScreenPersist.dart';
import 'package:Protalyze/pages/countdown/WorkoutToCountdownAdapter.dart';
import 'package:Protalyze/pages/countdown/CustomTimerPainter.dart';
import 'package:Protalyze/common/widget/SimpleListDialog.dart';
import 'package:Protalyze/common/widget/SingleMessageConfirmationDialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
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
  final int _prepareTime = 10;
  final Color _buttonsColor = Colors.white;
  bool _lastSecondsFlag = false;

  Future<AudioPlayer> playBeepSound() async => await (new AudioCache()).play("beep.mp3");

  @override
  void initState() {
    super.initState();
    ScreenPersist.enable();
    this._controller = AnimationController(vsync: this, value: 1.0);
    this._controller.addStatusListener((status) => animationStatusChanged(status));
    this._controller.addListener(() {
      Duration remainingSeconds = _controller.duration * _controller.value;
      if (remainingSeconds.inSeconds == 6)
        _lastSecondsFlag = true;
      else if (remainingSeconds.inSeconds == 5 && _lastSecondsFlag) {
        _lastSecondsFlag = false;
        playBeepSound();
      }
    });
    initializeCountdownElements();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Themes.systemUiOverlayStyleDark);
    return Scaffold(
      backgroundColor: Palette.darkGray,
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              children: <Widget>[
                buildCurrentTimeWidget(),
                buildExercisesWidget(),
                buildProgressCircle(),
                buildBottomButtons(context),
              ],
            );
          }
      )
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(Themes.systemUiOverlayStyleLight);
    ScreenPersist.disable();
    this._controller.dispose();
    super.dispose();
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
    this._totalTime = Duration(seconds: 0);
    // Add perform and rest times for each block
    this._countdownElements += WorkoutToCountdownAdapter.getCountdownElements(this.widget._workout);
    for (CountdownElement element in this._countdownElements){
      this._totalTime += element.totalTime;
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
    var currentTimeFontSize = 120.0;
    return SizedBox(height: 140, child: Container(
      alignment: Alignment.topCenter,
      child: Text(
        blockRemainingTimeString,
        style: TextStyle(fontSize: currentTimeFontSize, color: Colors.white,),
      ),
    )
    );
  }

  Widget buildExercisesWidget(){
    return Align(alignment: FractionalOffset.center,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(left: 70, right: 70),
          child: Container(
            height: 160.0,
            child: exercisesTexts,
            )
          ),
        ],
      ),
    );
  }

  Widget buildProgressCircle(){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Align(
          alignment: FractionalOffset.center,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: 
                  AnimatedBuilder(
                  animation: this._controller,
                  builder:
                      (BuildContext context, Widget child) {
                    return CustomPaint(
                        painter: CustomTimerPainter(
                          animation: this._controller,
                          backgroundColor: Colors.grey[700],
                          color1: Themes.normal.accentColor,
                          color2: Colors.red,
                    ));
                  },
                ),
                ),
                Center(child: 
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return TextButton(
                          onPressed: () {
                            togglePlayPause();
                            setState(() {});
                          },
                          child: Icon(
                            this.countdownFinished()? Icons.done : !this._isPause ? Icons.pause_outlined : Icons.play_arrow,
                            size: !this._isPause ? 80 : 90,
                            color: this._buttonsColor,
                          )
                          // child: Text(this.countdownFinished()? 'Done' : !this._isPause ? "Pause" : "Start", 
                          //   style: TextStyle(fontSize: 36.0, color: this._buttonsColor),)
                          
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

  Widget buildBottomButtons(BuildContext context){
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left:8.0,right:8.0,bottom:16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                handleSaveWorkoutButton(context);
              },
              child: Text("Save", style: TextStyle(fontSize: 24.0, color: this._buttonsColor))
            ),
            Column(
              children: [
                SizedBox(
                  height: 44.0,
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
                handleExitButton();
              },
              child: Text("Exit", style: TextStyle(fontSize: 24.0, color: this._buttonsColor))
            ),
          ],
        ),
      )
    );
  }

  void handleSaveWorkoutButton(BuildContext context){
    PastWorkout toSave = PastWorkout(Workout.copy(this.widget._workout), DateTime.now());
    Provider.of<PastWorkoutNotifier>(context, listen: false).addPastWorkout(toSave).then((v) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Workout registered!'),
      ));
    });
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

  Widget get exercisesTexts {
    if (this._countdownElements.isEmpty) {
      return Container(child: Text(
        'FINISHED',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40.0, color: Colors.white),
      ));
    } else if (this._countdownElements.length == 1) {
      return AutoSizeText(
        currentExerciseString,
        maxLines: 2,
        minFontSize: 10,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w300, color: Colors.white),
      );
    } else {
      return Column(children: [
        Expanded(child:
          AutoSizeText(
            currentExerciseString,
            maxLines: 2,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w300, color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: (){
            showNextExercisesListDialog();
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'AFTER',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Themes.normal.accentColor),
              ),
              SizedBox.fromSize(size: Size(4, 0),),
              Icon(
                Icons.remove_red_eye, 
                color: Themes.normal.accentColor,
                size: 22,
              ),
            ]
          )
        ),
        Expanded(child:
          AutoSizeText(
            nextExerciseString,
            maxLines: 1,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white70),
          )
        )]
      );
    }
  }

  void showNextExercisesListDialog() {
    if (this._countdownElements.length < 2) return;
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        SimpleListDialog(
          this._countdownElements.sublist(1).map((e) => e.name + ' (' + DurationFormatter.format(e.totalTime) + ')').toList(), 
          Themes.normal.primaryColor, 
          Colors.white70,
          'Next exercises'
        )
    );
  }

}

