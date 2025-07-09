// ignore_for_file: constant_identifier_names

class Workout {
  DateTime created = DateTime.now();
  DateTime updated = DateTime.now();
  String name = DateTime.now().toString();
  int id;
  int color;
  int sets = 1;
  int repetitions = 1;
  List<Exercise> exercises = [];

  Workout(this.id, this.color);

  Map<String, dynamic> toJson() => {
    'created': created.toIso8601String(),
    'updated': updated.toIso8601String(),
    'name': name,
    'id': id,
    'color': color,
    'sets': sets,
    'repetitions': repetitions,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  static Workout fromJson(Map<String, dynamic> json) {
    final workout = Workout(json['id'], json['color']);
    workout.created = DateTime.parse(json['created']);
    workout.updated = DateTime.parse(json['updated']);
    workout.name = json['name'];
    workout.sets = json['sets'] ?? 1;
    workout.repetitions = json['repetitions'] ?? 1;
    workout.exercises = (json['exercises'] as List<dynamic>)
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>)).toList();
    return workout;
  }
}

class Exercise {
  String name;
  WorkoutCategory category;
  int reps = 0;
  double weight = 0;

  Exercise(this.name, this.category);

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category.name,
    'reps': reps,
    'weight': weight,
  };

  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      json['name'],
      WorkoutCategory.values.firstWhere((e) => e.name == json['category']),
    )
      ..reps = json['reps'] ?? 0
      ..weight = (json['weight'] ?? 0).toDouble();
  }
}

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
