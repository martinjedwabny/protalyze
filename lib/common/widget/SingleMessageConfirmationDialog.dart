import 'package:flutter/material.dart';

class SingleMessageConfirmationDialog extends StatelessWidget{
  final String _title, _message;
  final VoidCallback _okEvent, _cancelEvent;
  SingleMessageConfirmationDialog(this._title, this._message, this._okEvent, this._cancelEvent);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this._title),
      content: Text(this._message),
      actions: [
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            this._okEvent();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            this._cancelEvent();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}