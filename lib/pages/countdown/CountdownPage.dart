import 'package:protalyze/common/utils/GifHandler.dart';
import 'package:protalyze/common/widget/TextInputAlertDialog.dart';
import 'package:protalyze/provider/PastWorkoutNotifier.dart';
import 'package:protalyze/config/Palette.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/countdown/CountdownElement.dart';
import 'package:protalyze/common/domain/PastWorkout.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';
import 'package:protalyze/common/utils/ScreenPersist.dart';
import 'package:protalyze/pages/countdown/WorkoutToCountdownAdapter.dart';
import 'package:protalyze/pages/countdown/CustomTimerPainter.dart';
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
  final Color _buttonsColor = Colors.white;
  bool _lastSecondsFlag = false;
  double _currentVolume = 0.5;

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
    SystemChrome.setSystemUIOverlayStyle(Themes.systemUiOverlayStyleDark);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.darkGray,
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildCurrentTimeWidget(),
                buildExercisesWidget(),
                buildProgressIndicator(),
                buildVolumeSlider(),
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

  bool isCountdownFinished() {
    return this._currentCountdownElementIndex == this._countdownElementList.length;
  }

  void stepToNextExercise() {
    if (isCountdownFinished()) return;
    bool shouldContinueAnimation = this._controller.isAnimating;
    this._totalTime -= this._controller.duration;
    this._currentCountdownElementIndex++;
    if (isCountdownFinished()) return;
    this._controller.duration = this._countdownElementList[this._currentCountdownElementIndex].totalTime;
    this._controller.value = 1.0;
    if (shouldContinueAnimation)
      this._controller.reverse();
  }

  void stepToPrevExercise() {
    if (isCountdownFinished()) return;
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
    if (newRemainingSeconds <= 0)
      stepToNextExercise();
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
            child: exercisesTexts,
            )
          ),
        ],
      ),
    );
  }

  Widget buildProgressIndicator(){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: AnimatedBuilder(
                    animation: this._controller,
                    builder: (BuildContext context, Widget child) {
                      return CustomPaint(
                        size: Size.infinite,
                          painter: CustomTimerPainter(
                            animation: this._controller,
                            backgroundColor: Colors.grey[700],
                            color1: Themes.normal.colorScheme.secondary,
                            color2: Colors.red,
                      ));
                    },
                  ),
                ),
              ),
            ),
            Center(child: 
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () { addSeconds(-5); }, 
                    child: Text('-5s', style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                  IconButton(
                    onPressed: () { stepToPrevExercise(); }, 
                    icon: Icon(Icons.fast_rewind, color: Colors.white, size: 30,)
                  ),
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
                  IconButton(
                    onPressed: () { stepToNextExercise();}, 
                    icon: Icon(Icons.fast_forward, color: Colors.white, size: 30,)
                  ),
                  TextButton(
                    onPressed: () { addSeconds(5); }, 
                    child: Text('+5s', style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                ],)
            )
          ],
        ),
      )
    );
  }

  Widget buildVolumeSlider(){
    Widget volumeDownIcon = Icon(Icons.volume_down_outlined, size: 24, color: Colors.white70, );
    Widget volumeUpIcon = Icon(Icons.volume_up_outlined, size: 24, color: Colors.white70,);
    Widget volumeSlider = Slider(
      value: _currentVolume, 
      onChanged: (double value) {
        setState(() {
          _currentVolume = value;
        });
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(padding: EdgeInsets.only(left: 20), child: volumeDownIcon),
        Expanded(child: volumeSlider),
        Padding(padding: EdgeInsets.only(right: 20), child: volumeUpIcon),
    ],);
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
    showDialog(
      context: context,
      builder: (_) {
        return TextInputAlertDialog('Enter workout notes', (String notes) {
          PastWorkout toSave = PastWorkout(Workout.copy(this.widget._workout), DateTime.now(), notes);
          Provider.of<PastWorkoutNotifier>(context, listen: false).addPastWorkout(toSave).then((v) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Workout registered!'),
            ));
          });
        }, initialValue: '', inputMaxLength: 1000,);
      },
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

  String get blockRemainingTimeString {
    return DurationFormatter.format(_controller.duration * _controller.value);
  }

  String get totalRemainingTimeString {
    if (isCountdownFinished())
      return DurationFormatter.format(this._totalTime);
    return DurationFormatter.format(this._totalTime - _controller.duration * (1.0 - _controller.value));
  }

  String get currentExerciseString {
    if (this._countdownElementList.length == 0) return '';
    String s = this._countdownElementList[this._currentCountdownElementIndex].name;
    return s;
  }

  String get currentExerciseGif {
    if (this._countdownElementList.length == 0) return '';
    return this._countdownElementList[this._currentCountdownElementIndex].gifUrl;
  }

  Widget get exercisesTexts {
    if (isCountdownFinished()) {
      return Container(child: Text(
        'FINISHED',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40.0, color: Colors.white),
      ));
    } else {
      Widget currentExerciseGifButton = createGifButton(currentExerciseString , currentExerciseGif, 30);
      var currentExerciseText = Text(
            currentExerciseString,
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w300, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
      );
      var currentExerciseTextContainer =
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Container(child: currentExerciseText)),
              SizedBox.fromSize(size: Size(12, 12),),
              currentExerciseGifButton,],);
      if (this._countdownElementList.length == 1)
        return Column(children: [currentExerciseTextContainer]);
      var nextExercisesTitle = Text(
            'AFTER',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: Themes.normal.colorScheme.secondary),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
      );
      var nextExercisesList = createNextExercisesList();
      return Column(
        children: [
            currentExerciseTextContainer,
            nextExercisesTitle,
            nextExercisesList,
        ]
      );
    }
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
          title: Text(title, style: TextStyle(color: Colors.white,),),
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

  Widget createNextExercisesList() {
    List<String> listElements = this._countdownElementList.sublist(1).map((e) => e.name.substring(0, e.name.length < 20 ? e.name.length : 20) + ' (' + DurationFormatter.format(e.totalTime) + ')').toList();
    return Container(
        height: 100,
        width: 300,
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black],
              stops: [0.8, 1.0],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: listElements.asMap().entries.map((entry) {
            String e = entry.value;
            return Card(
              margin: EdgeInsets.all(2),
              color: Colors.transparent,
              child: Text(e, style: TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
            );
          }
          ).toList(),
      )
      )
    );
  }

}

