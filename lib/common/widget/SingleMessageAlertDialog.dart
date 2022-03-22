import 'package:flutter/material.dart';

class SingleMessageAlertDialog extends StatelessWidget {
  final String _title, _message;
  SingleMessageAlertDialog(this._title, this._message);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_message),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
