import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownMessageAlertDialog extends StatelessWidget {
  const MarkdownMessageAlertDialog(this.title, this.markdownMessage);

  final String title;
  final String markdownMessage;

  final double width = 300.0;
  final double height = 300.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        width: width,
        height: height,
        child: Markdown(
          data: markdownMessage,
        ),
      ),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () {Navigator.of(context).pop();},
        ),
      ],
    );
  }
}