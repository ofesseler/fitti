import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitti/domain/workout.dart';
import 'package:fitti/widgets/exercise_controllers.dart';

void main() {
  test('Exercise gets a unique id and controller mapping is robust', () {
    final exercise1 = Exercise('Pushup', WorkoutCategory.Chest);
    final exercise2 = Exercise('Squat', WorkoutCategory.Legs);

    // Ensure unique ids
    expect(exercise1.id, isNotNull);
    expect(exercise2.id, isNotNull);
    expect(exercise1.id, isNot(equals(exercise2.id)));

    // Simulate controller mapping
    final Map<String, ExerciseControllers> controllers = {};
    controllers[exercise1.id] = ExerciseControllers(
      nameController: TextEditingController(),
      repsController: TextEditingController(),
      weightController: TextEditingController(),
    );
    controllers[exercise2.id] = ExerciseControllers(
      nameController: TextEditingController(),
      repsController: TextEditingController(),
      weightController: TextEditingController(),
    );

    // Remove one and check mapping
    controllers.remove(exercise1.id);
    expect(controllers.containsKey(exercise1.id), isFalse);
    expect(controllers.containsKey(exercise2.id), isTrue);
  });
}
