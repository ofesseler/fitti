
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
  final Map<String, ExerciseControllers> _exerciseControllers = {};
  late WorkoutListModel model;
  final Map<String, String?> _exerciseNameErrors = {};
  final Map<String, String?> _exerciseRepsErrors = {};
  final Map<String, String?> _exerciseWeightErrors = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = Provider.of<WorkoutListModel>(context, listen: false);
  }

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
  }
  Widget build(BuildContext context) {
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
                    exercise.id,
                    () => ExerciseControllers(
                      nameController: TextEditingController(text: exercise.name),
                      repsController: TextEditingController(text: exercise.reps.toString()),
                      weightController: TextEditingController(text: exercise.weight.toString()),
                    ),
                  );
                  return ExerciseCard(
                    key: ValueKey('exercise_card_${exercise.id}'),
                    exercise: exercise,
                    controllers: controllers,
                    nameError: _exerciseNameErrors[exercise.id],
                    repsError: _exerciseRepsErrors[exercise.id],
                    weightError: _exerciseWeightErrors[exercise.id],
                    onRemove: () async {
                      final shouldRemove = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Remove Exercise?'),
                          content: const Text('Are you sure you want to remove this exercise?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      );
                      if (shouldRemove == true) {
                        setState(() {
                          controllers.dispose();
                          _exerciseControllers.remove(exercise.id);
                          _exerciseNameErrors.remove(exercise.id);
                          _exerciseRepsErrors.remove(exercise.id);
                          _exerciseWeightErrors.remove(exercise.id);
                          workout.exercises.removeAt(index);
                          model.updateWorkout(workout);
                        });
                      }
                    },
                    onNameChanged: (val) {
                      setState(() {
                        if (val.trim().isEmpty) {
                          _exerciseNameErrors[exercise.id] = 'Name cannot be empty';
                        } else {
                          _exerciseNameErrors[exercise.id] = null;
                          exercise.name = val;
                          model.updateWorkout(workout);
                        }
                      });
                    },
                    onRepsChanged: (val) {
                      setState(() {
                        final parsed = int.tryParse(val);
                        if (parsed == null || parsed < 0) {
                          _exerciseRepsErrors[exercise.id] = 'Reps must be a positive number';
                        } else {
                          _exerciseRepsErrors[exercise.id] = null;
                          exercise.reps = parsed;
                          model.updateWorkout(workout);
                        }
                      });
                    },
                    onWeightChanged: (val) {
                      setState(() {
                        final parsed = double.tryParse(val);
                        if (parsed == null) {
                          _exerciseWeightErrors[exercise.id] = 'Weight must be a valid number';
                        } else {
                          _exerciseWeightErrors[exercise.id] = null;
                          exercise.weight = parsed;
                          model.updateWorkout(workout);
                        }
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
        tooltip: 'Add Exercise',
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            final newExercise = Exercise('', WorkoutCategory.Chest);
            workout.exercises.add(newExercise);
            model.updateWorkout(workout);
          });
        },
      ),
    );
  }
}



