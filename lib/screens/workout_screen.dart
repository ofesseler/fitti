import 'package:fitti/domain/workout.dart';
import 'package:fitti/domain/workout_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutScreen({super.key, required this.workout});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String dropdownValue = WorkoutCategory.Abs.name;
  late Workout workout;
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;
  late TextEditingController _setsController;
  late FocusNode _setsFocusNode;
  late TextEditingController _repsController;
  late FocusNode _repsFocusNode;

  @override
  void initState() {
    super.initState();
    workout = widget.workout;
    dropdownValue = workout.exercises.isNotEmpty
        ? workout.exercises.first.category.name
        : WorkoutCategory.Abs.name;
    _nameController = TextEditingController(text: workout.name);
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(_onNameFocusChange);
    _setsController = TextEditingController(text: workout.sets.toString());
    _setsFocusNode = FocusNode();
    _setsFocusNode.addListener(_onSetsFocusChange);
    _repsController = TextEditingController(text: workout.repetitions.toString());
    _repsFocusNode = FocusNode();
    _repsFocusNode.addListener(_onRepsFocusChange);
  }

  void _onNameFocusChange() {
    if (!_nameFocusNode.hasFocus) {
      final model = Provider.of<WorkoutListModel>(context, listen: false);
      if (workout.name != _nameController.text) {
        setState(() {
          workout.name = _nameController.text;
          model.updateWorkout(workout);
        });
      }
    }
  }

  void _onSetsFocusChange() {
    if (!_setsFocusNode.hasFocus) {
      final model = Provider.of<WorkoutListModel>(context, listen: false);
      int? newSets = int.tryParse(_setsController.text);
      if (newSets != null && workout.sets != newSets) {
        setState(() {
          workout.sets = newSets;
          model.updateWorkout(workout);
        });
      }
    }
  }

  void _onRepsFocusChange() {
    if (!_repsFocusNode.hasFocus) {
      final model = Provider.of<WorkoutListModel>(context, listen: false);
      int? newReps = int.tryParse(_repsController.text);
      if (newReps != null && workout.repetitions != newReps) {
        setState(() {
          workout.repetitions = newReps;
          model.updateWorkout(workout);
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.removeListener(_onNameFocusChange);
    _nameFocusNode.dispose();
    _setsController.dispose();
    _setsFocusNode.removeListener(_onSetsFocusChange);
    _setsFocusNode.dispose();
    _repsController.dispose();
    _repsFocusNode.removeListener(_onRepsFocusChange);
    _repsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkoutListModel>(context, listen: false);
    List<String> dropdownItems =
        WorkoutCategory.values.map((WorkoutCategory cat) {
      return cat.name;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(workout.created.toString()),
              DropdownButton(
                  value: dropdownValue,
                  items: dropdownItems.map((String cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (String? newDropdownValue) {
                    setState(() {
                      dropdownValue = newDropdownValue!;
                      if (workout.exercises.isNotEmpty) {
                        workout.exercises.first.category = WorkoutCategory.values.firstWhere((e) => e.name == dropdownValue);
                        model.updateWorkout(workout);
                      }
                    });
                  }),
              TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(labelText: 'Workout Name'),
                  onSubmitted: (String? fii) {
                    setState(() {
                      if (fii != null) {
                        workout.name = fii;
                        model.updateWorkout(workout);
                      }
                    });
                  }),
              const SizedBox(height: 16),
              TextField(
                controller: _setsController,
                focusNode: _setsFocusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Number of Sets'),
                onSubmitted: (String? value) {
                  int? newSets = int.tryParse(value ?? '');
                  if (newSets != null) {
                    setState(() {
                      workout.sets = newSets;
                      model.updateWorkout(workout);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _repsController,
                focusNode: _repsFocusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Number of Repetitions'),
                onSubmitted: (String? value) {
                  int? newReps = int.tryParse(value ?? '');
                  if (newReps != null) {
                    setState(() {
                      workout.repetitions = newReps;
                      model.updateWorkout(workout);
                    });
                  }
                },
              ),
            ],
          )),
    );
  }
}
