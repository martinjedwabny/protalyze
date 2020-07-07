import 'package:Protalyze/widgets/SingleMessageAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastWorkoutEditDialog extends StatefulWidget {
  final String title;
  final String initialName;
  final void Function(String text, DateTime dateTime) callback;
  DateTime selectedDate;

  PastWorkoutEditDialog(this.title, this.initialName, this.callback, this.selectedDate);

  @override
  _PastWorkoutEditDialogState createState() => _PastWorkoutEditDialogState();
}

class _PastWorkoutEditDialogState extends State<PastWorkoutEditDialog> {
  final controller = TextEditingController();

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.selectedDate)
      setState(() {
        widget.selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    this.controller.text = this.widget.initialName;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: controller,
          decoration: new InputDecoration(
          hintText: "Enter something",
          ),
        ),
        Row(children:[
          Text("Date: ${widget.selectedDate.toLocal()}".split(' ')[0]),
          FlatButton(
            onPressed: () => selectDate(context),
            child: Text(DateFormat("MMM d").format(widget.selectedDate)),
          ),
        ]),
      ]),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: () {
            if (controller.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleMessageAlertDialog('Error', 'Enter at least one character for the name.');
                },
              );
            } else {
              widget.callback(controller.text, widget.selectedDate);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}