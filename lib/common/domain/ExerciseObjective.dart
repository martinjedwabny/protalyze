class ExerciseObjective {
  String name;
  ExerciseObjective(this.name);
  ExerciseObjective.fromString(String string) : this.name = string;
  String toString() => this.name;
  static List<String> names =
    ['Chest','Back','Shoulders','Legs','Biceps','Triceps','Abs','Cardio'];
  @override
  bool operator ==(other) => other is ExerciseObjective && other.name == name;
  @override
  int get hashCode => names.contains(this.name) ? names.indexOf(this.name) : -1;

}