import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitti/screens/workout_screen.dart';
import 'package:fitti/widgets/exercise_card.dart';
import 'package:fitti/domain/workout.dart';
import 'package:provider/provider.dart';
import 'package:fitti/domain/workout_list_model.dart';

void main() {
  testWidgets('shows confirmation dialog and only removes on confirm', (WidgetTester tester) async {
    final workout = Workout(color: 0)..exercises.add(Exercise('Test', WorkoutCategory.Abs));
    final model = WorkoutListModel();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: model,
        child: MaterialApp(
          home: WorkoutScreen(workout: workout),
        ),
      ),
    );

    // Tap the remove button (assuming it's an IconButton in ExerciseCard)
    final removeButton = find.byIcon(Icons.delete);
    expect(removeButton, findsOneWidget);
    await tester.tap(removeButton);
    await tester.pumpAndSettle();

    // Dialog should appear
    expect(find.text('Remove Exercise?'), findsOneWidget);

    // Cancel: should not remove
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(ExerciseCard), findsOneWidget);

    // Tap remove again, then confirm
    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    // Exercise should be removed
    expect(find.byType(ExerciseCard), findsNothing);
  });
}
