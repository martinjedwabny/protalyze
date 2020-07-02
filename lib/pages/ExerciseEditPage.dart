import 'package:Protalyze/domain/Exercise.dart';
import 'package:Protalyze/domain/ExerciseBlock.dart';
import 'package:Protalyze/domain/Weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseEditPage extends StatefulWidget {
  ExerciseBlock block;
  ExerciseEditPage(this.block);

  @override
  _ExerciseEditPageState createState() => _ExerciseEditPageState();
}

class _ExerciseEditPageState extends State<ExerciseEditPage> {
  final nameControl = TextEditingController();
  final performTimeControl = TextEditingController();
  final restTimeControl = TextEditingController();
  final weightControl = TextEditingController();
  final maxRepsControl = TextEditingController();
  final minRepsControl = TextEditingController();
  Map<String,bool> checkboxInputs = Map();

  @override
  Widget build(BuildContext context) {
    nameControl.text = widget.block.exercise.name;
    performTimeControl.text = widget.block.performingTime.inSeconds.toString();
    restTimeControl.text = widget.block.restTime.inSeconds.toString();
    weightControl.text = widget.block.weight == null ? null : widget.block.weight.amount.toString();
    maxRepsControl.text = widget.block.maxReps == null ? null : widget.block.maxReps.toString();
    minRepsControl.text = widget.block.minReps == null ? null : widget.block.minReps.toString();
    if (checkboxInputs['reps'] == null) 
      checkboxInputs['reps'] = widget.block.inputReps;
    if (checkboxInputs['diff'] == null) 
      checkboxInputs['diff'] = widget.block.inputDifficulty;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit exercise'),
      ),
      body: ListView(children: [
        cardTextInputRow('Name', nameControl),
        cardTextInputNumericRow('Performing duration (seconds)', performTimeControl),
        cardTextInputNumericRow('Rest duration (seconds)', restTimeControl),
        cardTextInputNumericRow('Weight (kg)', weightControl),
        cardTextInputNumericRow('Min reps', minRepsControl),
        cardTextInputNumericRow('Max reps', maxRepsControl),
        cardCheckboxInputRow('Input reps', 'reps'),
        cardCheckboxInputRow('Input difficulty', 'diff'),
        Center(child: ButtonBar(
          mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
          children: <Widget>[
            RaisedButton(
              child: Text('Ok', style: TextStyle(color: Colors.white),),
              onPressed: () {okayPress();},
            ),
            RaisedButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white),),
              onPressed: (){cancelPress();},
            ),
          ],
        ),
        ),
      ],),
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: () {Navigator.of(context).pop();},
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  okayPress(){
    ExerciseBlock block = widget.block;
    if (nameControl.text != null && nameControl.text.length > 0){
      block.exercise = Exercise(nameControl.text);
    } else {
      return showAlertDialog(context, "Error", "Name should not be empty.");
    }
    if (performTimeControl.text != null && performTimeControl.text.length > 0){
      block.performingTime = Duration(seconds: int.parse(performTimeControl.text)); 
    } else {
      return showAlertDialog(context, "Error", "Performing time should not be empty.");
    }
    if (restTimeControl.text != null && restTimeControl.text.length > 0){
      block.restTime = Duration(seconds: int.parse(restTimeControl.text)); 
    } else {
      return showAlertDialog(context, "Error", "Rest time should not be empty.");
    }
    block.weight = weightControl.text.length == 0 ? null : Weight(int.parse(weightControl.text), WeightType.kilos);
    block.minReps = minRepsControl.text.length == 0 ? null : int.parse(minRepsControl.text); 
    block.maxReps = maxRepsControl.text.length == 0 ? null : int.parse(maxRepsControl.text);
    block.inputReps = this.checkboxInputs['reps'];
    block.inputDifficulty = this.checkboxInputs['diff'];
    Navigator.pop(context, () {
      setState(() {});
    });
  }

  cancelPress(){
    Navigator.pop(context);
  }

  cardTextInputRow(name, controller){
    return Card(child: ListTile(
        title: Text(name),
        subtitle: TextField(
                controller: controller,
                decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Enter something",),
              ),
            ),
        );
  }

  cardTextInputNumericRow(name, controller){
    return Card(child: ListTile(
        title: Text(name),
        subtitle: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Enter a number"),
              ),
            )
        );
  }

  cardCheckboxInputRow(name, key){
    return Card(child: CheckboxListTile(
      title: Text(name),
      value: this.checkboxInputs[key],
      onChanged: (newValue) { 
        setState(() {
          this.checkboxInputs[key] = newValue; 
        }); 
      },
      controlAffinity: ListTileControlAffinity.leading,
      )
    );
  }
  
}