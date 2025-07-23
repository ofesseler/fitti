import 'package:flutter/material.dart';
import 'package:fitti/domain/workout.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final dynamic controllers;
  final VoidCallback onRemove;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onRepsChanged;
  final ValueChanged<String> onWeightChanged;
  final ValueChanged<WorkoutCategory?> onCategoryChanged;
  final Key? cardKey;

  const ExerciseCard({
    required this.exercise,
    required this.controllers,
    required this.onRemove,
    required this.onNameChanged,
    required this.onRepsChanged,
    required this.onWeightChanged,
    required this.onCategoryChanged,
    this.cardKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: cardKey,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllers.nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: onNameChanged,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Remove Exercise',
                  onPressed: onRemove,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<WorkoutCategory>(
                    value: exercise.category,
                    items: WorkoutCategory.values.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat.name),
                    )).toList(),
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controllers.repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    onChanged: onRepsChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controllers.weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Weight'),
                    onChanged: onWeightChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
