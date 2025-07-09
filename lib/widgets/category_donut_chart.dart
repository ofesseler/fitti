import 'package:flutter/material.dart';
import 'package:fitti/domain/workout.dart';

class CategoryDonutChart extends StatelessWidget {
  final List<Workout> workouts;
  const CategoryDonutChart({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    // Count exercises per category
    final Map<WorkoutCategory, int> categoryCounts = {};
    for (var category in WorkoutCategory.values) {
      categoryCounts[category] = 0;
    }
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        categoryCounts[exercise.category] = (categoryCounts[exercise.category] ?? 0) + 1;
      }
    }
    final total = categoryCounts.values.fold(0, (a, b) => a + b);
    if (total == 0) {
      return const Center(child: Text('No exercises to display'));
    }
    // Define a color for each category
    final Map<WorkoutCategory, Color> categoryColors = {
      WorkoutCategory.Abs: Colors.orange,
      WorkoutCategory.Back: Colors.blue,
      WorkoutCategory.Biceps: Colors.green,
      WorkoutCategory.Cardio: Colors.pink,
      WorkoutCategory.Chest: Colors.red,
      WorkoutCategory.Legs: Colors.purple,
      WorkoutCategory.Shoulders: Colors.teal,
      WorkoutCategory.Triceps: Colors.brown,
    };
    // Prepare data for the chart
    final List<_DonutSection> sections = [];
    categoryCounts.forEach((cat, count) {
      if (count > 0) {
        sections.add(_DonutSection(
          category: cat,
          count: count,
          color: categoryColors[cat]!,
        ));
      }
    });
    return SizedBox(
      height: 200,
      width: 200,
      child: CustomPaint(
        painter: _DonutChartPainter(sections, total),
        child: Center(
          child: Text('Exercises\nby Category', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}

class _DonutSection {
  final WorkoutCategory category;
  final int count;
  final Color color;
  _DonutSection({required this.category, required this.count, required this.color});
}

class _DonutChartPainter extends CustomPainter {
  final List<_DonutSection> sections;
  final int total;
  _DonutChartPainter(this.sections, this.total);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2;
    final thickness = radius * 0.4;
    double startAngle = -3.14 / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;
    for (final section in sections) {
      final sweepAngle = (section.count / total) * 3.14 * 2;
      paint.color = section.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - thickness / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
