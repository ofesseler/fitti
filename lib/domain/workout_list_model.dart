import 'package:flutter/material.dart';
import 'workout.dart';

class WorkoutListModel extends ChangeNotifier {
  final List<Workout> _workouts = [];

  List<Workout> get workouts => _workouts;

  void addWorkout(Workout workout) {
    _workouts.insert(0, workout);
    notifyListeners();
  }

  void updateWorkout(Workout updatedWorkout) {
    int idx = _workouts.indexWhere((w) => w.id == updatedWorkout.id);
    if (idx != -1) {
      _workouts[idx] = updatedWorkout;
      notifyListeners();
    }
  }
}
