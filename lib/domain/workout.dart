// ignore_for_file: constant_identifier_names

class Workout {
  DateTime created = DateTime.now();
  DateTime updated = DateTime.now();
  String name = DateTime.now().toString();
  int id;
  int color;
  List<Exercise> exercises = [];

  Workout(this.id, this.color);
}

class Exercise {
  String name;
  WorkoutCategory category;
  int reps = 0;
  double weight = 0;

  Exercise(this.name, this.category);
}

// class WorkoutType {
//   String name;
//   WorkoutCategory category;

//   WorkoutType()
// }

enum WorkoutCategory {
  Abs,
  Back,
  Biceps,
  Cardio,
  Chest,
  Legs,
  Shoulders,
  Triceps
}
