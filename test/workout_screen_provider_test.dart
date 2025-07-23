import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fitti/domain/workout_list_model.dart';
import 'package:fitti/domain/workout.dart';
import 'package:fitti/screens/workout_screen.dart';

void main() {
  testWidgets('WorkoutScreen updates provider when name changes', (WidgetTester tester) async {
    final model = WorkoutListModel();
    final workout = Workout(color: 1);
    model.addWorkout(workout);

    await tester.pumpWidget(
      ChangeNotifierProvider<WorkoutListModel>.value(
        value: model,
        child: MaterialApp(
          home: WorkoutScreen(workout: workout, focusName: false),
        ),
      ),
    );

    // Enter a new name
    await tester.enterText(find.byType(TextField).first, 'Test Workout');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(model.workouts.first.name, 'Test Workout');
  });

  testWidgets('WorkoutScreen updates provider when exercise name changes', (WidgetTester tester) async {
    final model = WorkoutListModel();
    final workout = Workout(color: 1);
    workout.exercises.add(Exercise('Old Name', WorkoutCategory.Abs));
    model.addWorkout(workout);

    await tester.pumpWidget(
      ChangeNotifierProvider<WorkoutListModel>.value(
        value: model,
        child: MaterialApp(
          home: WorkoutScreen(workout: workout, focusName: false),
        ),
      ),
    );

    // Enter a new exercise name
    await tester.enterText(find.byType(TextField).at(1), 'New Exercise Name');
    await tester.pump();

    expect(model.workouts.first.exercises.first.name, 'New Exercise Name');
  });
}
