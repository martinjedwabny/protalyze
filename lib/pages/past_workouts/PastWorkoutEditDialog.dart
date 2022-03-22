import 'package:protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PastWorkoutEditDialog extends StatefulWidget {
  final String _title;
  final String _initialName;
  final DateTime _initialDate;
  final String _initialNotes;
  final void Function(String text, DateTime dateTime, String notes) _callback;

  PastWorkoutEditDialog(this._title, this._initialName, this._initialDate,
      this._initialNotes, this._callback);

  @override
  _PastWorkoutEditDialogState createState() => _PastWorkoutEditDialogState();
}

class _PastWorkoutEditDialogState extends State<PastWorkoutEditDialog> {
  final _workoutNameTextController = TextEditingController();
  final _workoutNotesTextController = TextEditingController();
  DateTime _selectedDate;

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget._initialDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget._initialDate)
      setState(() {
        this._selectedDate = picked;
      });
  }

  @override
  void initState() {
    this._workoutNameTextController.text = this.widget._initialName;
    this._workoutNotesTextController.text = this.widget._initialNotes;
    this._selectedDate = widget._initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget._title),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workout name:'),
            TextField(
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(20),
              ],
              controller: _workoutNameTextController,
              decoration: new InputDecoration(
                hintText: "Enter workout name",
              ),
            ),
            Text('Comments:'),
            TextField(
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(2000),
              ],
              controller: _workoutNotesTextController,
              maxLines: null,
              decoration: new InputDecoration(
                hintText: "Enter comments",
              ),
            ),
            Row(children: [
              Text("Date: ${this._selectedDate.toLocal()}".split(' ')[0]),
              TextButton(
                onPressed: () => selectDate(context),
                child: Text(DateFormat("MMM d").format(this._selectedDate)),
              ),
            ]),
          ]),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            if (_workoutNameTextController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleMessageAlertDialog(
                      'Error', 'Enter at least one character for the name.');
                },
              );
            } else {
              widget._callback(this._workoutNameTextController.text,
                  this._selectedDate, this._workoutNotesTextController.text);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
