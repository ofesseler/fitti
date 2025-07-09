import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitti/widgets/category_donut_chart.dart';
import 'package:fitti/domain/workout.dart';

void main() {
  group('CategoryDonutChart', () {
    testWidgets('shows no exercises message when empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: CategoryDonutChart(workouts: [])),
      ));
      expect(find.text('No exercises to display'), findsOneWidget);
    });

    testWidgets('shows legend and chart for categories', (tester) async {
      final workouts = [
        Workout(1, 1)
          ..exercises = [
            Exercise('Pushup', WorkoutCategory.Chest)..reps = 10,
            Exercise('Situp', WorkoutCategory.Abs)..reps = 20,
            Exercise('Squat', WorkoutCategory.Legs)..reps = 15,
          ]
      ];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CategoryDonutChart(workouts: workouts)),
      ));
      expect(find.text('Chest (1)'), findsOneWidget);
      expect(find.text('Abs (1)'), findsOneWidget);
      expect(find.text('Legs (1)'), findsOneWidget);
      expect(find.text('Exercises\nby Category'), findsOneWidget);
    });
  });
}
