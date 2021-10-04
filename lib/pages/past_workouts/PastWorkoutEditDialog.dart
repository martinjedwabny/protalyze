import 'package:protalize/common/widget/SingleMessageAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PastWorkoutEditDialog extends StatefulWidget {
  final String _title;
  final String _initialName;
  final void Function(String text, DateTime dateTime) _callback;
  final DateTime _initialDate;

  PastWorkoutEditDialog(this._title, this._initialName, this._callback, this._initialDate);

  @override
  _PastWorkoutEditDialogState createState() => _PastWorkoutEditDialogState();
}

class _PastWorkoutEditDialogState extends State<PastWorkoutEditDialog> {
  final _controller = TextEditingController();
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
    this._controller.text = this.widget._initialName;
    this._selectedDate = widget._initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget._title),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(20),],
          controller: _controller,
          decoration: new InputDecoration(
          hintText: "Enter something",
          ),
        ),
        Row(children:[
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
            if (_controller.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleMessageAlertDialog('Error', 'Enter at least one character for the name.');
                },
              );
            } else {
              widget._callback(_controller.text, this._selectedDate);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}