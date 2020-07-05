import 'package:flutter/material.dart';

class SingleMessageAlertDialog extends StatelessWidget{
  final String title, message;
  SingleMessageAlertDialog(this.title, this.message);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: () {Navigator.of(context).pop();},
        ),
      ],
    );
  }
}