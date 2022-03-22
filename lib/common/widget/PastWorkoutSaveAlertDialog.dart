import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:protalyze/common/domain/Workout.dart';

class PastWorkoutSaveAlertDialog extends StatefulWidget {
  final Map<int, Workout> options;
  final void Function(Workout selected, DateTime date, String comments)
      callback;
  PastWorkoutSaveAlertDialog(this.options, this.callback);
  @override
  _PastWorkoutSaveAlertDialog createState() => _PastWorkoutSaveAlertDialog();
}

class _PastWorkoutSaveAlertDialog<T> extends State<PastWorkoutSaveAlertDialog> {
  Workout _selectedOption;
  DateTime _selectedDate = DateTime.now();
  final _commentsController = TextEditingController();

  @override
  void initState() {
    this._selectedOption = widget.options[widget.options.keys.first];
    super.initState();
  }

  Future<Null> selectDate(BuildContext context) async {
    var now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != now)
      setState(() {
        this._selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Register a workout'),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select an option:'),
            DropdownButton<Workout>(
              value: this._selectedOption,
              items: widget.options.keys.map((int key) {
                return DropdownMenuItem<Workout>(
                  value: widget.options[key],
                  child: new Text(widget.options[key].name),
                );
              }).toList(),
              onChanged: (Workout newValue) {
                setState(() {
                  this._selectedOption = newValue;
                });
              },
            ),
            Text('Date:'),
            TextButton(
              onPressed: () => selectDate(context),
              child: Text(DateFormat("MMM d").format(this._selectedDate)),
            ),
            Text('Comments:'),
            TextField(
              maxLines: null,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(2000),
              ],
              controller: _commentsController,
              decoration: new InputDecoration(
                hintText: "Enter comments",
              ),
            ),
          ]),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
            widget.callback(this._selectedOption, this._selectedDate,
                this._commentsController.text);
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
