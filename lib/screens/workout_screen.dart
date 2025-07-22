import 'package:fitti/domain/workout.dart';
import 'package:fitti/domain/workout_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;
  final bool focusName;
  const WorkoutScreen({super.key, required this.workout, this.focusName = false});

  @override
  WorkoutScreenState createState() => WorkoutScreenState();
}

class WorkoutScreenState extends State<WorkoutScreen> {
  late Workout workout;
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;
  final Map<int, TextEditingController> _repsControllers = {};
  final Map<int, TextEditingController> _nameControllers = {};
  final Map<int, TextEditingController> _weightControllers = {};

  String getDefaultWorkoutName() {
    final now = DateTime.now();
    final weekday = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][now.weekday - 1];
    String partOfDay;
    if (now.hour < 12) {
      partOfDay = "morning";
    } else if (now.hour < 18) {
      partOfDay = "afternoon";
    } else {
      partOfDay = "evening";
    }
    return "$weekday $partOfDay workout";
  }

  @override
  void initState() {
    super.initState();
    workout = widget.workout;
    _nameController = TextEditingController(text: workout.name);
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(_onNameFocusChange);
    if (widget.focusName) {
      // Focus after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _nameFocusNode.requestFocus();
      });
    }
  }

  void _onNameFocusChange() {
    if (!_nameFocusNode.hasFocus) {
      final model = Provider.of<WorkoutListModel>(context, listen: false);
      String enteredName = _nameController.text.trim();
      if (enteredName.isEmpty) {
        // Generate name based on time of day
        final now = DateTime.now();
        final weekday = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][now.weekday - 1];
        String partOfDay;
        if (now.hour < 12) {
          partOfDay = "morning";
        } else if (now.hour < 18) {
          partOfDay = "afternoon";
        } else {
          partOfDay = "evening";
        }
        enteredName = "$weekday $partOfDay workout";
        _nameController.text = enteredName;
      }
      if (workout.name != enteredName) {
        setState(() {
          workout.name = enteredName;
          model.updateWorkout(workout);
        });
      }
    }
  }

  void _addExercise(BuildContext context) {
    final model = Provider.of<WorkoutListModel>(context, listen: false);
    setState(() {
      workout.exercises.add(Exercise('New Exercise', WorkoutCategory.Abs));
      model.updateWorkout(workout);
    });
  }

  void _removeExercise(BuildContext context, int index) {
    final model = Provider.of<WorkoutListModel>(context, listen: false);
    setState(() {
      workout.exercises.removeAt(index);
      model.updateWorkout(workout);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.removeListener(_onNameFocusChange);
    _nameFocusNode.dispose();
    for (final c in _repsControllers.values) {
      c.dispose();
    }
    for (final c in _nameControllers.values) {
      c.dispose();
    }
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkoutListModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(workout.created.toString()),
              TextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  hintText: getDefaultWorkoutName(),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                onSubmitted: (String? fii) {
                  setState(() {
                    if (fii != null) {
                      workout.name = fii;
                      model.updateWorkout(workout);
                    }
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text('Exercises', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workout.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = workout.exercises[index];
                  _repsControllers.putIfAbsent(index, () => TextEditingController(text: exercise.reps.toString()));
                  _nameControllers.putIfAbsent(index, () => TextEditingController(text: exercise.name));
                  _weightControllers.putIfAbsent(index, () => TextEditingController(text: exercise.weight.toString()));
                  return Card(
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
                                  controller: _nameControllers[index],
                                  decoration: const InputDecoration(labelText: 'Name'),
                                  onChanged: (val) {
                                    setState(() {
                                      exercise.name = val;
                                      Provider.of<WorkoutListModel>(context, listen: false).updateWorkout(workout);
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Remove Exercise',
                                onPressed: () {
                                  setState(() {
                                    _repsControllers[index]?.dispose();
                                    _repsControllers.remove(index);
                                    _nameControllers[index]?.dispose();
                                    _nameControllers.remove(index);
                                    _weightControllers[index]?.dispose();
                                    _weightControllers.remove(index);
                                    _removeExercise(context, index);
                                  });
                                },
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
                                  onChanged: (cat) {
                                    setState(() {
                                      if (cat != null) exercise.category = cat;
                                      Provider.of<WorkoutListModel>(context, listen: false).updateWorkout(workout);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _repsControllers[index],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Reps'),
                                  onChanged: (val) {
                                    setState(() {
                                      exercise.reps = int.tryParse(val) ?? 0;
                                      Provider.of<WorkoutListModel>(context, listen: false).updateWorkout(workout);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _weightControllers[index],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Weight'),
                                  onChanged: (val) {
                                    setState(() {
                                      exercise.weight = double.tryParse(val) ?? 0;
                                      Provider.of<WorkoutListModel>(context, listen: false).updateWorkout(workout);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExercise(context),
        tooltip: 'Add Exercise',
        child: const Icon(Icons.add),
      ),
    );
  }
}
