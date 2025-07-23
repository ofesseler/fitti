import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fitti/domain/workout_list_model.dart';
import 'package:fitti/domain/workout.dart';
import 'package:fitti/screens/workout_screen.dart';

void main() {
  testWidgets('Exercise controllers are created and disposed properly', (WidgetTester tester) async {
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

    // There should be a TextField for the workout name and 3 for the exercise (name, reps, weight)
    expect(find.byType(TextField), findsNWidgets(4)); // 1 + 3

    // Add an exercise
    await tester.tap(find.byTooltip('Add Exercise'));
    await tester.pump();
    expect(find.byType(TextField), findsNWidgets(7)); // 1 + 2*3

    // Remove the first exercise
    await tester.tap(find.byTooltip('Remove Exercise').first);
    await tester.pump();
    expect(find.byType(TextField), findsNWidgets(4)); // 1 + 1*3
  });

  testWidgets('Edge case: removing all exercises does not crash', (WidgetTester tester) async {
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

    // Remove the only exercise
    await tester.tap(find.byTooltip('Remove Exercise'));
    await tester.pump();
    expect(find.byType(TextField), findsOneWidget); // only workout name field remains
  });
}
