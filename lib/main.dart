import 'package:fitti/screens/workout_screen.dart';
import 'package:fitti/domain/workout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Overview());
}

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Fitti(title: 'Track workouts'),
    );
  }
}

class Fitti extends StatefulWidget {
  const Fitti({super.key, required this.title});
  final String title;

  @override
  State<Fitti> createState() => _FittiState();
}

class _FittiState extends State<Fitti> {
  int _counter = 0;
  List<Workout> workoutContainers = [];

  void _createNewWorkout() {
    setState(() {
      _counter++;
      var foo = Workout(_counter, 50);
      foo.exercises.insert(0, Exercise("butterfly", WorkoutCategory.Shoulders));
      workoutContainers.insert(0, foo);
      _navigateToWorkoutScreen(context, foo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have this many workouts so far:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: workoutContainers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          child: Container(
                            color: Colors.amber,
                            child: Row(children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workoutContainers[index].name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            "Date ${workoutContainers[index].created}"),
                                      ]),
                                ),
                              ),
                              Column(children: [
                                Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(children: <Widget>[
                                      for (var workout
                                          in workoutContainers[index].exercises)
                                        Text(workout.category.name)
                                    ]))
                              ]),
                            ]),
                          ),
                          onTap: () => _navigateToWorkoutScreen(
                              context, workoutContainers[index]),
                        ));
                  })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createNewWorkout,
          tooltip: 'New Workout',
          child: const Icon(Icons.add),
        ));
  }

  Future<dynamic> _navigateToWorkoutScreen(
      BuildContext context, Workout workout) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutScreen(),
        settings: RouteSettings(
          arguments: workout,
        ),
      ),
    );
  }
}
