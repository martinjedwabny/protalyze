class ExerciseObjective {
  String name;
  ExerciseObjective(this.name);
  ExerciseObjective.fromString(String string) : this.name = string;
  String toString() => this.name;
  static List<String> names = [
    'Chest',
    'Back',
    'Shoulders',
    'Legs',
    'Biceps',
    'Triceps',
    'Abs',
    'Cardio',
    'Other'
  ];
  @override
  bool operator ==(other) => other is ExerciseObjective && other.name == name;
  @override
  int get hashCode => this.name.hashCode;
}
