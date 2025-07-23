// ignore_for_file: constant_identifier_names

import 'package:uuid/uuid.dart';

class Workout {
  DateTime created = DateTime.now();
  DateTime updated = DateTime.now();
  String name = DateTime.now().toString();
  String id;
  int color;
  int sets = 1;
  int repetitions = 1;
  List<Exercise> exercises = [];

  Workout({String? id, required this.color}) : id = id ?? const Uuid().v4();

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
    final workout = Workout(id: json['id'], color: json['color']);
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
  final String id;
  String name;
  WorkoutCategory category;
  int reps = 0;
  double weight = 0;

  Exercise(this.name, this.category, {String? id}) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category.name,
    'reps': reps,
    'weight': weight,
  };

  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      json['name'],
      WorkoutCategory.values.firstWhere((e) => e.name == json['category']),
      id: json['id'],
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
