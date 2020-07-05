import 'package:Protalyze/widgets/SingleMessageAlertDialog.dart';
import 'package:flutter/material.dart';

class TextInputAlertDialog extends StatelessWidget{
  final String title;
  final String initialValue;
  final void Function(String text) callback;
  final controller = TextEditingController();
  TextInputAlertDialog(this.title, this.callback, {this.initialValue = ''});
  @override
  Widget build(BuildContext context) {
    this.controller.text = this.initialValue;
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: "Enter something",
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: () {
            if (controller.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleMessageAlertDialog('Error', 'Enter at least one character.');
                },
              );
            } else {
              callback(controller.text);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}