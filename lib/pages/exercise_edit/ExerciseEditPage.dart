import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:protalyze/common/domain/ExerciseObjective.dart';
import 'package:protalyze/common/utils/DurationFormatter.dart';
import 'package:protalyze/common/utils/GifHandler.dart';
import 'package:protalyze/common/widget/FloatingScaffold.dart';
import 'package:protalyze/common/widget/FloatingScaffoldSection.dart';
import 'package:protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:protalyze/common/widget/TimePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protalyze/config/Themes.dart';

class ExerciseEditPage extends StatefulWidget {
  final ExerciseBlock block;
  final VoidCallback okayCallback;
  ExerciseEditPage(this.block, this.okayCallback);

  @override
  _ExerciseEditPageState createState() => _ExerciseEditPageState();
}

class _ExerciseEditPageState extends State<ExerciseEditPage> {
  final nameControl = TextEditingController();
  final setsControl = TextEditingController();
  Duration performTimeControl;
  Duration restTimeControl;
  Map<String, bool> objectivesInput = Map();
  String gifUrl;

  @override
  void initState() {
    nameControl.text = widget.block.name;
    setsControl.text =
        widget.block.sets != null ? widget.block.sets.toString() : '1';
    this.performTimeControl = widget.block.performingTime;
    this.restTimeControl = widget.block.restTime;
    for (String o in ExerciseObjective.names) objectivesInput[o] = false;
    for (ExerciseObjective o in widget.block.objectives)
      objectivesInput[o.toString()] = true;
    this.gifUrl = widget.block.gifUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingScaffold(
      appBar: AppBar(
        title: Text('Edit exercise'),
      ),
      body: FloatingScaffoldSection(child: getEditWorkoutBody()),
    );
  }

  ListView getEditWorkoutBody() {
    return ListView(
      children: [
        cardTextInputRow('Description', nameControl),
        cardTextInputNumericRow('Sets', setsControl),
        cardDurationInputRow('Performing duration', this.performTimeControl,
            (Duration duration) {
          setState(() => this.performTimeControl = duration);
        }),
        cardDurationInputRow('Rest duration', this.restTimeControl,
            (Duration duration) {
          setState(() => this.restTimeControl = duration);
        }),
        cardGifInputRow('GIF', this.gifUrl, (String gifUrl) {
          setState(() => this.gifUrl = gifUrl);
        }),
        cardCheckboxInputRow('Targets', objectivesInput),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () {
                  okayPress();
                },
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () {
                  cancelPress();
                },
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
          ],
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleMessageAlertDialog(title, message);
      },
    );
  }

  okayPress() {
    ExerciseBlock block = widget.block;
    if (nameControl.text != null && nameControl.text.length > 0) {
      block.name = nameControl.text;
    } else {
      return showAlertDialog(context, "Error", "Name should not be empty.");
    }
    block.performingTime = performTimeControl;
    block.restTime = restTimeControl;
    block.sets = setsControl.text.length == 0 ? 1 : int.parse(setsControl.text);
    block.objectives = [];
    objectivesInput.forEach((key, value) {
      if (value) block.objectives.add(ExerciseObjective.fromString(key));
    });
    block.gifUrl = this.gifUrl;
    widget.okayCallback();
    Navigator.pop(context, () {});
  }

  cancelPress() {
    Navigator.pop(context);
  }

  cardTextInputRow(name, controller) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: TextField(
          controller: controller,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(100),
          ],
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Enter something",
          ),
        ),
      ),
    );
  }

  cardTextInputNumericRow(name, controller, [int maxNumbers = 2]) {
    return Card(
        child: ListTile(
      title: Text(name),
      subtitle: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxNumbers),
        ],
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Enter a number"),
      ),
    ));
  }

  cardCheckboxInputRow(String name, Map<String, bool> input) {
    ListTile title = ListTile(title: Text(name));
    List<CheckboxListTile> options = input.keys
        .map((String option) => CheckboxListTile(
              title: Text(option),
              value: input[option],
              activeColor: Themes.normal.colorScheme.secondary,
              onChanged: (newValue) {
                setState(() {
                  input[option] = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ))
        .toList();
    return Card(child: Column(children: <Widget>[title] + options));
  }

  cardDurationInputRow(
      String name, Duration initialValue, Function(Duration) callback) {
    return Card(
      child: ListTile(
          title: Text(name),
          subtitle: InkWell(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Text(DurationFormatter.formatWithLetters(initialValue)),
            onTap: () {
              TimePicker(initialValue, (Duration time) {
                callback(time);
              }).showDialog(context);
            },
          )),
    );
  }

  cardGifInputRow(String name, String initialValue, Function(String) callback) {
    Widget title = ListTile(
      title: Row(children: [
        Text(name),
        IconButton(
          icon: Icon(Icons.edit, size: 16),
          tooltip: 'Edit',
          onPressed: () {
            GifHandler.searchGif(context).then((String gifUrl) {
              setState(() {
                this.gifUrl = gifUrl;
              });
            });
          },
        ),
      ]),
    );
    Widget gif = this.gifUrl == null || this.gifUrl == ''
        ? SizedBox(width: 1, height: 1)
        : GifHandler.createGifImage(gifUrl, height: 150);
    return Card(
        child: Column(
      children: <Widget>[title, gif],
    ));
  }
}
