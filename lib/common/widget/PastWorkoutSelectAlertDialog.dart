import 'package:flutter/material.dart';
import 'package:protalyze/common/domain/Workout.dart';

class PastWorkoutSelectAlertDialog extends StatefulWidget {
  final Map<String, Workout> options;
  final void Function(Workout selected) callback;
  PastWorkoutSelectAlertDialog(this.options, this.callback);
  @override
  _PastWorkoutSelectAlertDialog createState() => _PastWorkoutSelectAlertDialog();
}

class _PastWorkoutSelectAlertDialog<T> extends State<PastWorkoutSelectAlertDialog> {
  Workout _selectedOption;

  @override
  void initState() {
    this._selectedOption = widget.options[widget.options.keys.first];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Register a workout'),
      content: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text('Select an option:'),
        DropdownButton<Workout>(
          value: this._selectedOption,
          items: widget.options.keys.map((String key) {
            return DropdownMenuItem<Workout>(
              value: widget.options[key],
              child: new Text(key),
            );
          }).toList(),
          onChanged: (Workout newValue) {
            setState(() {  
              this._selectedOption = newValue;
            });
          },
        ),
      ]),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
            widget.callback(this._selectedOption);
          },
        ),
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}