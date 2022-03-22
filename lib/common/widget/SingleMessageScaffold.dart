import 'package:flutter/material.dart';

class SingleMessageScaffold extends StatelessWidget {
  final message;
  SingleMessageScaffold(this.message);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.headline6,
      ),
    ));
  }
}
