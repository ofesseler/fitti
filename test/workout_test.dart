import 'package:flutter_test/flutter_test.dart';
import 'package:fitti/domain/workout.dart';

void main() {
  group('Workout', () {
    test('Workout can be created and serialized', () {
      final workout = Workout(1, 42)
        ..name = 'Test Workout'
        ..exercises = [
          Exercise('Pushup', WorkoutCategory.Chest)
            ..reps = 10
            ..weight = 0,
          Exercise('Squat', WorkoutCategory.Legs)
            ..reps = 15
            ..weight = 0,
        ];
      final json = workout.toJson();
      final fromJson = Workout.fromJson(json);
      expect(fromJson.name, 'Test Workout');
      expect(fromJson.exercises.length, 2);
      expect(fromJson.exercises[0].name, 'Pushup');
      expect(fromJson.exercises[1].category, WorkoutCategory.Legs);
    });

    test('Exercise serialization', () {
      final exercise = Exercise('Situp', WorkoutCategory.Abs)
        ..reps = 20
        ..weight = 0;
      final json = exercise.toJson();
      final fromJson = Exercise.fromJson(json);
      expect(fromJson.name, 'Situp');
      expect(fromJson.category, WorkoutCategory.Abs);
      expect(fromJson.reps, 20);
    });
  });
}
