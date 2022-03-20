import 'package:protalyze/config/Themes.dart';
import 'package:flutter/material.dart';

class FloatingScaffold extends StatelessWidget {
  final AppBar appBar;
  final Widget body;
  final Widget floatingActionButton;
  FloatingScaffold({this.appBar, this.body, this.floatingActionButton});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.only(top: 16, bottom: 0, left: 8, right: 16),
          child: this.appBar
        ),
      ),
      backgroundColor: Themes.normal.scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child:this.body
              )
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: this.floatingActionButton,
      );
  }
}