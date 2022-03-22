import 'package:flutter/material.dart';
import 'package:protalyze/config/Themes.dart';

class CountdownBottomButtons extends StatefulWidget {
  final Function handleSaveWorkout;
  final Function handleTapComment;

  const CountdownBottomButtons(this.handleSaveWorkout, this.handleTapComment);
  @override
  _CountdownBottomButtonsState createState() => _CountdownBottomButtonsState();
}

class _CountdownBottomButtonsState extends State<CountdownBottomButtons> {
  final Color buttonsColor = Themes.normal.colorScheme.secondary;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildSaveButton(),
          buildCommentButton(),
        ],
      ),
    ));
  }

  Widget buildSaveButton() {
    return buildIconButton(Icons.save_alt_outlined, 'Save', () {
      this.widget.handleSaveWorkout();
    });
  }

  Widget buildCommentButton() {
    return buildIconButton(Icons.add_comment_outlined, 'Comment', () {
      this.widget.handleTapComment();
    });
  }

  Widget buildIconButton(IconData icon, String text, Function callback) {
    var commentTextAndIcon = Container(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: buttonsColor),
              SizedBox.fromSize(
                size: Size(12, 12),
              ),
              Text(
                text,
                style: TextStyle(color: buttonsColor, fontSize: 20),
              ),
            ]));
    return TextButton(onPressed: () => callback(), child: commentTextAndIcon);
  }
}
