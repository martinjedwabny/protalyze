import 'package:protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupBlockEditDialog extends StatelessWidget {
  final String title;
  final int initialSets;
  final void Function(int sets) callback;
  final setsController = TextEditingController();
  GroupBlockEditDialog(this.title, this.callback, {this.initialSets = 1});
  @override
  Widget build(BuildContext context) {
    this.setsController.text = this.initialSets.toString();
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: setsController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: new InputDecoration(
              hintText: "Enter sets",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            if (setsController.text == '' || int.parse(setsController.text) < 1)
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleMessageAlertDialog(
                      'Error', 'Number of sets should be at least one.');
                },
              );
            else {
              callback(int.parse(setsController.text));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
