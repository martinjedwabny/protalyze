import 'package:protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputAlertDialog extends StatelessWidget{
  final String title;
  final String initialValue;
  final int inputMaxLength;
  final bool nullInput;
  final bool multilineInput;
  final void Function(String text) callback;
  final controller = TextEditingController();
  TextInputAlertDialog(this.title, this.callback, {this.initialValue = '', this.inputMaxLength = 40, this.nullInput = false, this.multilineInput = false});
  @override
  Widget build(BuildContext context) {
    this.controller.text = this.initialValue;
    return AlertDialog(
      title: Text(title),
      content: TextField(
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(this.inputMaxLength),],
        controller: controller,
        decoration: new InputDecoration(
        hintText: "Enter something",
        ),
        keyboardType: this.multilineInput ? TextInputType.multiline : TextInputType.text,
        maxLines: this.multilineInput ? null : 1,
      ),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            if (controller.text.isEmpty && !nullInput) {
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