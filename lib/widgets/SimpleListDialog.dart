import 'package:flutter/material.dart';

class SimpleListDialog extends StatelessWidget {
  final List<String> listElements;
  final Color backgroundColor;
  final Color textColor;
  const SimpleListDialog(this.listElements, this.backgroundColor, this.textColor);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: this.backgroundColor,
      content: Container(
        height: 400,
        width: 200,
        child: ListView(
        // padding: EdgeInsets.all(16),
        children: this.listElements.map((String e) => 
          Card(
            color: Colors.transparent,
            child: Text(e, style: TextStyle(color: this.textColor)),
          )
        ).toList(),
      )
      ),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {Navigator.of(context).pop();},
        ),
      ],

    );
  }
}