import 'package:flutter/material.dart';

class SinglePickerAlertDialog<T> extends StatefulWidget {
  final String title, inputTitle;
  final Map<int, T> options;
  final void Function(T selected) callback;
  SinglePickerAlertDialog(this.title, this.inputTitle, this.options, this.callback);
  @override
  _SinglePickerAlertDialogState<T> createState() => _SinglePickerAlertDialogState<T>();
}

class _SinglePickerAlertDialogState<T> extends State<SinglePickerAlertDialog<T>> {
  T selectedOption;

  @override
  void initState() {
    this.selectedOption = widget.options[widget.options.keys.first];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(widget.inputTitle),
        DropdownButton<T>(
          value: this.selectedOption,
          items: widget.options.keys.map((int key) {
            return DropdownMenuItem<T>(
              value: widget.options[key],
              child: new Text(widget.options[key].toString()),
            );
          }).toList(),
          onChanged: (T newValue) {
            setState(() {  
              this.selectedOption = newValue;
            });
          },
        )
      ]),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
            widget.callback(this.selectedOption);
          },
        ),
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}