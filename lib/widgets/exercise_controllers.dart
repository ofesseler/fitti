import 'package:flutter/material.dart';

class ExerciseControllers {
  final TextEditingController nameController;
  final TextEditingController repsController;
  final TextEditingController weightController;

  ExerciseControllers({
    required this.nameController,
    required this.repsController,
    required this.weightController,
  });

  void dispose() {
    nameController.dispose();
    repsController.dispose();
    weightController.dispose();
  }
}
