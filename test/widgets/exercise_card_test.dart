import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitti/widgets/exercise_card.dart';
import 'package:fitti/domain/workout.dart';

void main() {
  group('ExerciseCard', () {
    testWidgets('renders with initial values and responds to input', (WidgetTester tester) async {
      final exercise = Exercise('Push Up', WorkoutCategory.Biceps);
      exercise.reps = 10;
      exercise.weight = 0;
      final nameController = TextEditingController(text: exercise.name);
      final repsController = TextEditingController(text: exercise.reps.toString());
      final weightController = TextEditingController(text: exercise.weight.toString());
      bool removed = false;
      String? changedName;
      String? changedReps;
      String? changedWeight;
      WorkoutCategory? changedCategory;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ExerciseCard(
              exercise: exercise,
              controllers: _TestControllers(
                nameController: nameController,
                repsController: repsController,
                weightController: weightController,
              ),
              onRemove: () => removed = true,
              onNameChanged: (val) => changedName = val,
              onRepsChanged: (val) => changedReps = val,
              onWeightChanged: (val) => changedWeight = val,
              onCategoryChanged: (cat) => changedCategory = cat,
            ),
          ),
        ),
      );

      // Check initial values
      final nameField = tester.widget<TextField>(find.byType(TextField).at(0));
      final repsField = tester.widget<TextField>(find.byType(TextField).at(1));
      final weightField = tester.widget<TextField>(find.byType(TextField).at(2));
      expect(nameField.controller?.text, 'Push Up');
      expect(repsField.controller?.text, '10');
      expect(weightField.controller?.text, '0.0');

      // Change name
      await tester.enterText(find.byType(TextField).at(0), 'Sit Up');
      expect(changedName, 'Sit Up');

      // Change reps
      await tester.enterText(find.byType(TextField).at(1), '15');
      expect(changedReps, '15');

      // Change weight
      await tester.enterText(find.byType(TextField).at(2), '5');
      expect(changedWeight, '5');

      // Change category
      await tester.tap(find.byType(DropdownButton<WorkoutCategory>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abs').last);
      await tester.pumpAndSettle();
      expect(changedCategory, WorkoutCategory.Abs);

      // Remove
      await tester.tap(find.byIcon(Icons.delete));
      expect(removed, isTrue);
    });
  });
}

// Helper for test controllers
class _TestControllers {
  final TextEditingController nameController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  _TestControllers({
    required this.nameController,
    required this.repsController,
    required this.weightController,
  });
}
