
import 'package:fitti/domain/workout.dart';
import 'package:fitti/domain/workout_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitti/widgets/exercise_card.dart';
import 'package:fitti/widgets/exercise_controllers.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;
  final bool focusName;
  const WorkoutScreen({Key? key, required this.workout, this.focusName = false}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Workout workout;
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;
  final Map<int, ExerciseControllers> _exerciseControllers = {};
  late WorkoutListModel model;

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
      String enteredName = _nameController.text.trim();
      if (enteredName.isEmpty) {
        enteredName = getDefaultWorkoutName();
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
    setState(() {
      workout.exercises.add(Exercise('New Exercise', WorkoutCategory.Abs));
      model.updateWorkout(workout);
    });
  }

  void _removeExercise(BuildContext context, int index) {
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
    for (final c in _exerciseControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<WorkoutListModel>(context, listen: false);
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
                  final controllers = _exerciseControllers.putIfAbsent(
                    index,
                    () => ExerciseControllers(
                      nameController: TextEditingController(text: exercise.name),
                      repsController: TextEditingController(text: exercise.reps.toString()),
                      weightController: TextEditingController(text: exercise.weight.toString()),
                    ),
                  );
                  return ExerciseCard(
                    key: ValueKey('exercise_card_$index'),
                    exercise: exercise,
                    controllers: controllers,
                    onRemove: () {
                      setState(() {
                        controllers.dispose();
                        _exerciseControllers.remove(index);
                        _removeExercise(context, index);
                      });
                    },
                    onNameChanged: (val) {
                      setState(() {
                        exercise.name = val;
                        model.updateWorkout(workout);
                      });
                    },
                    onRepsChanged: (val) {
                      setState(() {
                        exercise.reps = int.tryParse(val) ?? 0;
                        model.updateWorkout(workout);
                      });
                    },
                    onWeightChanged: (val) {
                      setState(() {
                        exercise.weight = double.tryParse(val) ?? 0;
                        model.updateWorkout(workout);
                      });
                    },
                    onCategoryChanged: (cat) {
                      setState(() {
                        if (cat != null) exercise.category = cat;
                        model.updateWorkout(workout);
                      });
                    },
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



