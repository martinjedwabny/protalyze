import 'package:protalyze/common/utils/GifHandler.dart';
import 'package:protalyze/config/Palette.dart';
import 'package:protalyze/pages/countdown/CountdownControls.dart';
import 'package:protalyze/pages/countdown/CountdownExercisesInfo.dart';
import 'package:protalyze/pages/countdown/CountdownProgressIndicator.dart';
import 'package:protalyze/pages/countdown/CountdownVolumeSlider.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/countdown/CountdownElement.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';
import 'package:protalyze/common/utils/ScreenPersist.dart';
import 'package:protalyze/pages/countdown/WorkoutToCountdownAdapter.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class CountDownPage extends StatefulWidget {
  final Workout _workout;
  final Function _saveWorkoutCallback;
  CountDownPage(this._workout, this._saveWorkoutCallback);
  @override
  _CountDownPageState createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> with TickerProviderStateMixin {

  // Progress animation
  AnimationController _controller;
  bool _isPause = true;
  Duration _totalTime;
  final int _prepareTime = 10;
  bool _lastSecondsFlag = false;

  // Workout state elements
  List<CountdownElement> _countdownElementList;
  int _currentCountdownElementIndex = 0;
  
  // Alert beep sound
  double _currentVolume = 0.5;
  Future<AudioPlayer> playBeepSound() async => await (new AudioCache()).play("beep.mp3", volume: _currentVolume * 0.75);

  // UI
  var progressIndicatorHorizontalPadding = 20.0;
  var currentTimeFontSize = 90.0;
  var currentExerciseFontSize = 30.0;

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
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildProgressIndicator(),
              buildExercisesWidget(),
              SizedBox(width: 1,height: 8,),
              buildControls(),
            ],
          );
        }
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
      stepToNextExercise(forceContinue: true);
    }
  }

  bool isCountdownFinished() {
    return this._currentCountdownElementIndex == this._countdownElementList.length;
  }

  void stepToNextExercise({bool forceContinue = false}) {
    if (isCountdownFinished()) {
      this.widget._saveWorkoutCallback(); 
    } else {
      bool shouldContinueAnimation = this._controller.isAnimating || forceContinue;
      this._totalTime -= this._controller.duration;
      this._currentCountdownElementIndex++;
      if (isCountdownFinished()) {
        this._controller.duration = Duration.zero;
        this._controller.value = 1.0;
        this._totalTime = Duration.zero;
        this._controller.reverse();
      } else {
        this._controller.duration = this._countdownElementList[this._currentCountdownElementIndex].totalTime;
        this._controller.value = 1.0;
        if (shouldContinueAnimation)
          this._controller.reverse();
      }
    }
  }

  void stepToPrevExercise() {
    if (isCountdownFinished() || this._currentCountdownElementIndex == 0) return;
    bool shouldContinueAnimation = this._controller.isAnimating;
    this._currentCountdownElementIndex--;
    this._controller.duration = this._countdownElementList[this._currentCountdownElementIndex].totalTime;
    this._controller.value = 1.0;
    this._totalTime += this._controller.duration;
    if (shouldContinueAnimation)
      this._controller.reverse();
  }

  void addSeconds(int seconds) {
    bool shouldContinueAnimation = this._controller.isAnimating;
    int pastRemainingSeconds = (this._controller.duration.inSeconds * this._controller.value).toInt();
    int newRemainingSeconds = pastRemainingSeconds + seconds;
    if (newRemainingSeconds <= 0) {
      stepToNextExercise();
      return;
    }
    if (seconds > 0) {
      this._controller.duration += Duration(seconds: seconds);
      this._totalTime += Duration(seconds: seconds);
    } else {
      this._controller.duration -= Duration(seconds: -seconds);
      this._totalTime -= Duration(seconds: -seconds);
    }
    this._controller.value = newRemainingSeconds.toDouble() / this._controller.duration.inSeconds.toDouble();
    if (shouldContinueAnimation)
      this._controller.reverse();
  }

  void initializeCountdownElements(){
    // Set initial duration / prepare time to this._prepareTime seconds
    this._controller.duration = Duration(seconds: this._prepareTime);
    this._countdownElementList = [new CountdownElement('Prepare', new Duration(seconds: this._prepareTime), '')];
    this._totalTime = Duration(seconds: 0);
    // Add perform and rest times for each block
    this._countdownElementList += WorkoutToCountdownAdapter.getCountdownElements(this.widget._workout);
    for (CountdownElement element in this._countdownElementList){
      this._totalTime += element.totalTime;
    }
    this._currentCountdownElementIndex = 0;
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

  Widget buildExercisesWidget(){
    return CountdownExercisesInfo(
      this._controller, 
      this._countdownElementList, 
      () => this._currentCountdownElementIndex, 
      this._totalTime);
  }

  Widget buildProgressIndicator(){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:progressIndicatorHorizontalPadding, vertical: 0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: CountdownProgressIndicator(_controller)
              ),
            ),
            Center(child: buildCurrentExerciseSection()),
          ],
        ),
        ),
    );
  }

  Widget buildCurrentExerciseSection() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      buildCurrentTimeWidget(),
      buildCurrentExerciseWidget(),
    ],
  );

  Widget buildCurrentTimeWidget() {
    return Padding(
      padding: const EdgeInsets.only(top:20.0),
      child: Text(
          blockRemainingTimeString,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 0.9,
            fontSize: currentTimeFontSize, 
            color: Themes.normal.colorScheme.primary.withAlpha(220),)
      ),
    );
  }

  Widget buildCurrentExerciseWidget() {
    if (countdownFinished()) return Text('');
    Widget currentExerciseGifButton = createGifButton(currentExerciseString , currentExerciseGif, 24);
    var currentExerciseText = Text(
            currentExerciseString,
            maxLines: 1,
            style: TextStyle(
              fontSize: currentExerciseFontSize, 
              height: 0.9,
              color: Palette.darkGray.withAlpha(220),
              ),
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
      );
      return Row(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: FittedBox(fit:BoxFit.scaleDown,child: currentExerciseText)),
            SizedBox.fromSize(size: Size(12, 12),),
            currentExerciseGifButton,],);
  }

  Widget createGifButton(String title, String gifUrl, double size) {
    return gifUrl == null || gifUrl == '' ? SizedBox(width: 1, height: 1) : GestureDetector(
      onTap: () {showGifDialog(title, gifUrl);}, 
      child: Icon(Icons.ondemand_video, size: size, color: Themes.normal.colorScheme.secondary,));
  }

  void showGifDialog(String title, String gifUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        AlertDialog(
          title: Text(title, style: TextStyle(color: Palette.darkGray,),),
          backgroundColor: Themes.normal.colorScheme.primary,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[GifHandler.createGifImage(gifUrl, width: 400)],
          ),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {Navigator.of(context).pop();},
            ),
          ],
        )
    );
  }

  String get currentExerciseString {
    if (this._countdownElementList.length == 0 || countdownFinished()) return '';
    String s = this._countdownElementList[this._currentCountdownElementIndex].name;
    return s;
  }

  String get currentExerciseGif {
    if (this._countdownElementList.length == 0 || countdownFinished()) return '';
    return this._countdownElementList[this._currentCountdownElementIndex].gifUrl;
  }

  Widget buildControls() {
    return Container(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        ),
        child: Column(children: [
          Center(child: CountdownControls(
            this._controller, 
            () => stepToPrevExercise(), 
            () => stepToNextExercise(), 
            () => togglePlayPause(), 
            () => addSeconds(-5), 
            () => addSeconds(5), 
            () => this.countdownFinished(), 
            () => this._isPause)
          ),
          buildVolumeSlider(),
          ],),
        ),
      );
  }

  Widget buildVolumeSlider(){
    return CountdownVolumeSlider(
      this._currentVolume, 
      (volume) {this._currentVolume = volume;}
    );
  }

  String get blockRemainingTimeString {
    return DurationFormatter.format(_controller.duration * _controller.value);
  }

  String get totalRemainingTimeString {
    if (isCountdownFinished())
      return DurationFormatter.format(this._totalTime);
    return DurationFormatter.format(this._totalTime - _controller.duration * (1.0 - _controller.value));
  }

}

