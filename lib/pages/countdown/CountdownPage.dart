import 'package:protalyze/common/widget/TextInputAlertDialog.dart';
import 'package:protalyze/pages/countdown/CountdownBottomButtons.dart';
import 'package:protalyze/pages/countdown/CountdownControls.dart';
import 'package:protalyze/pages/countdown/CountdownExercisesInfo.dart';
import 'package:protalyze/pages/countdown/CountdownProgressIndicator.dart';
import 'package:protalyze/pages/countdown/CountdownVolumeSlider.dart';
import 'package:protalyze/provider/PastWorkoutNotifier.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/countdown/CountdownElement.dart';
import 'package:protalyze/common/domain/PastWorkout.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';
import 'package:protalyze/common/utils/ScreenPersist.dart';
import 'package:protalyze/pages/countdown/WorkoutToCountdownAdapter.dart';
import 'package:protalyze/common/widget/SingleMessageConfirmationDialog.dart';
import 'package:flutter/material.dart';
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
  List<CountdownElement> _countdownElementList;
  int _currentCountdownElementIndex = 0;
  final int _prepareTime = 10;
  bool _lastSecondsFlag = false;
  double _currentVolume = 0.5;
  String _comments = '';

  Future<AudioPlayer> playBeepSound() async => await (new AudioCache()).play("beep.mp3", volume: _currentVolume * 0.75);

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
            children: <Widget>[
              buildExercisesWidget(),
              buildProgressIndicator(),
              buildCommentsButton(),
              buildVolumeSlider(),
              buildBottomButtons(context),
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
    if (isCountdownFinished()) return;
    bool shouldContinueAnimation = this._controller.isAnimating || forceContinue;
    this._totalTime -= this._controller.duration;
    this._currentCountdownElementIndex++;
    if (isCountdownFinished()) return;
    this._controller.duration = this._countdownElementList[this._currentCountdownElementIndex].totalTime;
    this._controller.value = 1.0;
    if (shouldContinueAnimation)
      this._controller.reverse();
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
      child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: CountdownProgressIndicator(_controller)
              ),
            ),
            Center(child: CountdownControls(
              this._controller, 
              () => stepToPrevExercise(), 
              () => stepToNextExercise(), 
              () => togglePlayPause(), 
              () => addSeconds(-5), 
              () => addSeconds(5), 
              () => this.countdownFinished(), 
              () => this._isPause)
            )
          ],
        ),
    );
  }

  Widget buildVolumeSlider(){
    return CountdownVolumeSlider(
      this._currentVolume, 
      (volume) {this._currentVolume = volume;}
    );
  }

  Widget buildBottomButtons(BuildContext context){
    return CountdownBottomButtons(
      () => totalRemainingTimeString, 
      () => handleSaveWorkoutButton(context), 
      () => handleExitButton()
    );
  }

  void handleSaveWorkoutButton(BuildContext context){
    PastWorkout toSave = PastWorkout(Workout.copy(this.widget._workout), DateTime.now(), this._comments);
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
    if (isCountdownFinished())
      return DurationFormatter.format(this._totalTime);
    return DurationFormatter.format(this._totalTime - _controller.duration * (1.0 - _controller.value));
  }


  Widget buildCommentsButton() {
    var commentTextAndIcon = Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_comment_outlined, color: Themes.normal.colorScheme.secondary),
          SizedBox.fromSize(size: Size(12, 12),),
          Text('Comments', style: TextStyle(color: Themes.normal.colorScheme.secondary, fontSize: 20),),
        ]));
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () { handleTapComment();}, 
        child: commentTextAndIcon)
      );
  }

  void handleTapComment(){
    showDialog(
      context: context,
      builder: (_) {
        return TextInputAlertDialog('Comments', (String notes) {
          this._comments = notes;
        }, 
        initialValue: this._comments, 
        inputMaxLength: 2000,
        nullInput: true,
        multilineInput: true,);
      },
    );
  }

}

