enum ExerciseObjectiveType {
  Chest,
  Back,
  Shoulders,
  Legs,
  Biceps,
  Triceps,
  Abs,
  Cardio
}

class ExerciseObjective {
  ExerciseObjectiveType type;
  ExerciseObjective(this.type);
  static List<String> get types => [
    'Chest',
    'Back',
    'Shoulders',
    'Legs',
    'Biceps',
    'Triceps',
    'Abs',
    'Cardio'];
  String toString() {
    switch (this.type) {
      case ExerciseObjectiveType.Chest:
        return 'Chest';
      case ExerciseObjectiveType.Back:
        return 'Back';
      case ExerciseObjectiveType.Shoulders:
        return 'Shoulders';
      case ExerciseObjectiveType.Legs:
        return 'Legs';
      case ExerciseObjectiveType.Biceps:
        return 'Biceps';
      case ExerciseObjectiveType.Triceps:
        return 'Triceps';
      case ExerciseObjectiveType.Abs:
        return 'Abs';
      case ExerciseObjectiveType.Cardio:
        return 'Cardio';
      default:
        return '';
    }
  }
  ExerciseObjective.fromString(String string) {
    switch (string) {
      case 'Chest':
        this.type = ExerciseObjectiveType.Chest;
        break;
      case 'Back':
        this.type = ExerciseObjectiveType.Back;
        break;
      case 'Shoulders':
        this.type = ExerciseObjectiveType.Shoulders;
        break;
      case 'Legs':
        this.type = ExerciseObjectiveType.Legs;
        break;
      case 'Biceps':
        this.type = ExerciseObjectiveType.Biceps;
        break;
      case 'Triceps':
        this.type = ExerciseObjectiveType.Triceps;
        break;
      case 'Abs':
        this.type = ExerciseObjectiveType.Abs;
        break;
      case 'Cardio':
        this.type = ExerciseObjectiveType.Cardio;
        break;
      default:
        this.type = null;
    }
  }
}