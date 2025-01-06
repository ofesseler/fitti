import 'package:fitti/domain/workout.dart';
import 'package:flutter/material.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String dropdownValue = WorkoutCategory.Abs.name;
  late Workout workout;

  

  @override
  Widget build(BuildContext context) {
    workout = ModalRoute.of(context)!.settings.arguments as Workout;
    List<String> dropdownItems =
        WorkoutCategory.values.map((WorkoutCategory cat) {
      return cat.name;
    }).toList();

    // Use the Todo to create the UI.
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
                    });
                  }),
              TextField(
                  decoration: InputDecoration(labelText: workout.name),
                  onSubmitted: (String? fii) {
                    setState(() {
                      if (fii != null) {
                        workout.name = fii;
                      }
                    });
                  }),
            ],
          )),
    );
  }
}
