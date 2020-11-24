import 'package:Protalyze/common/domain/ExerciseObjective.dart';
import 'package:flutter/material.dart';

class ExerciseObjectiveTag extends StatelessWidget {
  const ExerciseObjectiveTag({
    Key key,
    @required this.objective,
    this.size = 16.0,
  }) : super(key: key);

  final ExerciseObjective objective;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    List<Color> options = [
      Colors.red[300],
      Colors.red[700],
      Colors.orange[300],
      Colors.orange[700],
      Colors.blue[300],
      Colors.blue[700],
      Colors.green[300],
      Colors.green[700],];
    if (this.objective != null && ExerciseObjective.names.contains(objective.name))
      color = options.elementAt(ExerciseObjective.names.indexOf(objective.name));
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.circle, size: size, color: color),
        Text(this.objective.name.substring(0,1), style: TextStyle(color: Colors.white, fontSize: 7))
      ]);
  }
}