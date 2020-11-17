import 'package:Protalyze/widgets/SingleMessageAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupBlockEditDialog extends StatelessWidget{
  final String title;
  final String initialText;
  final int initialSets;
  final void Function(String text, int sets) callback;
  final nameController = TextEditingController();
  final setsController = TextEditingController();
  GroupBlockEditDialog(this.title, this.callback, {this.initialText = '', this.initialSets = 1});
  @override
  Widget build(BuildContext context) {
    this.nameController.text = this.initialText;
    this.setsController.text = this.initialSets.toString();
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(20),],
            controller: nameController,
            decoration: new InputDecoration(
            hintText: "Enter name",),),
          TextField(
            controller: setsController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),],
            decoration: new InputDecoration(
            hintText: "Enter sets",),),
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: () {
            if (nameController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleMessageAlertDialog('Error', 'Enter at least one character.');
                },
              );
            } else {
              if (setsController.text == '' || int.parse(setsController.text) < 1)
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleMessageAlertDialog('Error', 'Number of sets should be at least one.');
                  },
                );
                else {
                  callback(nameController.text, int.parse(setsController.text));
                  Navigator.of(context).pop();
                }
            }
          },
        ),
      ],
    );
  }
}