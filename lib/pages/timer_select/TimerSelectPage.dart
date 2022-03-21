import 'package:flutter/material.dart';
import 'package:protalyze/common/domain/PastWorkout.dart';
import 'package:protalyze/common/domain/Workout.dart';
import 'package:protalyze/common/widget/FloatingScaffold.dart';
import 'package:protalyze/common/widget/SingleMessageConfirmationDialog.dart';
import 'package:protalyze/common/widget/TextInputAlertDialog.dart';
import 'package:protalyze/pages/countdown/CountdownPage.dart';
import 'package:protalyze/provider/PastWorkoutNotifier.dart';
import 'package:protalyze/provider/WorkoutNotifier.dart';
import 'package:provider/provider.dart';

class TimerSelectPage extends StatefulWidget {
  const TimerSelectPage();

  @override
  State<TimerSelectPage> createState() => _TimerSelectPageState();
}

class _TimerSelectPageState extends State<TimerSelectPage> with AutomaticKeepAliveClientMixin {
  Workout selectedWorkout;
  Workout currentOption;
  String _comments = '';
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // SystemChrome.setSystemUIOverlayStyle(Themes.systemUiOverlayStyleDark);
    return FloatingScaffold(
      appBar: AppBar(
        title: Text('Timer'),
        leading: buildBackButton(), 
        actions: buildActionButtons(),
      ),
      // resizeToAvoidBottomInset: false,
      // backgroundColor: Palette.darkGray,
      body: this.selectedWorkout == null ? 
        buildUnselected() : 
        buildSelected()
    );
  }

  Widget buildBackButton() {
    return this.selectedWorkout != null ? 
      IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {handleExitButton();},
      ) : null;
  }

  List<Widget> buildActionButtons() {
    return this.selectedWorkout != null ? 
      [
        IconButton(
          icon: Icon(Icons.save_outlined),
          onPressed: () {handleSaveWorkoutButton(context);},
        ),
        IconButton(
          icon: Icon(Icons.add_comment_outlined),
          onPressed: () {handleTapComment();},
        )
       ] : [];
  }



  void handleSaveWorkoutButton(BuildContext context){
    PastWorkout toSave = PastWorkout(Workout.copy(this.selectedWorkout), DateTime.now(), this._comments);
    Provider.of<PastWorkoutNotifier>(context, listen: false).addPastWorkout(toSave).then((v) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Workout registered!'),
      ));
    });
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

  Widget buildUnselected() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(150),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        width: 300.0,
        child: Consumer<WorkoutNotifier>(
        builder: (context, notifier, widget) {
          List<Workout> workouts = notifier.workouts;
          return workouts.isEmpty ? 
            buildEmptyWorkouts() : 
            buildNotEmptyWorkouts(workouts);
          }
        )
      ),
    );
  }

  Widget buildEmptyWorkouts() {
    return Text(
        'Please create a workout to start a timer',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0),
      
    );
  }

  Widget buildNotEmptyWorkouts(List<Workout> workouts) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTitle(),
        buildWorkoutSelector(workouts),
        buildPlayButton(),
      ],
    );
  }

  Widget buildSelected() {
    return CountDownPage(this.selectedWorkout);
  }

  void handleExitButton(){
    showDialog(
      context: context,
      builder: (_) {
        return SingleMessageConfirmationDialog("Exit", "Do you really want to exit?", 
        (){
          setState(() {
            this.selectedWorkout = null;
            this._comments = '';
          });
        }, 
        (){});
      },
    );
  }

  Widget buildTitle() {
    var fontSize = 30.0;
    return Text('Select a workout:',style: TextStyle(fontSize: fontSize));
  }

  Widget buildWorkoutSelector(List<Workout> workouts) {
    Map<String, Workout> options = workouts.asMap().map((key, value) => MapEntry(value.name, value));
    if (this.currentOption == null)
      this.currentOption = options.isEmpty ? null : options[options.keys.first];
    return DropdownButton<Workout>(
      isExpanded: true,
      value: this.currentOption,
      // dropdownColor: Palette.darkGray,
      items: options.keys.map((String key) {
        return DropdownMenuItem<Workout>(
          value: options[key],
          child: new Text(key,),
        );
      }).toList(),
      onChanged: (Workout newValue) {
        setState(() {  
          this.currentOption = newValue;
        });
      },
    );
  }

  Widget buildPlayButton() {
    return Consumer<WorkoutNotifier>(
      builder: (context, notifier, widget) {
        return Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: notifier.workouts.isEmpty ? null : () => handleStartWorkout(), 
            style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12.0)), ),
            child: Text('Start workout', style: TextStyle(color: Colors.white, fontSize: 20.0),)),
        );
      }
    );
  }

  void handleStartWorkout() {
    setState(() {
      this.selectedWorkout = this.currentOption;
    });
  }

  
}