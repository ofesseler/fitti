import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fitti/domain/workout_list_model.dart';
import 'package:fitti/domain/workout.dart';
import 'package:fitti/screens/workout_screen.dart';

void main() {
  testWidgets('shows error for empty exercise name and invalid reps/weight', (WidgetTester tester) async {
    final model = WorkoutListModel();
    final workout = Workout(color: 1);
    workout.exercises.add(Exercise('Pushup', WorkoutCategory.Chest));
    model.addWorkout(workout);

    await tester.pumpWidget(
      ChangeNotifierProvider<WorkoutListModel>.value(
        value: model,
        child: MaterialApp(
          home: WorkoutScreen(workout: workout, focusName: false),
        ),
      ),
    );

    // Find the name TextField and clear it
    final nameField = find.widgetWithText(TextField, 'Name').first;
    await tester.enterText(nameField, '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Should show error for empty name
    expect(find.text('Name cannot be empty'), findsOneWidget);

    // Enter invalid reps
    final repsField = find.widgetWithText(TextField, 'Reps').first;
    await tester.enterText(repsField, '-5');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Reps must be a positive number'), findsOneWidget);

    // Enter invalid weight
    final weightField = find.widgetWithText(TextField, 'Weight').first;
    await tester.enterText(weightField, 'abc');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Weight must be a valid number'), findsOneWidget);
  });
}
