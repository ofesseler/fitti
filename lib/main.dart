import 'package:fitti/screens/workout_screen.dart';
import 'package:fitti/domain/workout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Overview());
}

class Overview extends StatelessWidget {
  const Overview({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitti',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Fitti(title: 'Track workouts'),
    );
  }
}

class Fitti extends StatefulWidget {
  const Fitti({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Fitti> createState() => _FittiState();
}

class _FittiState extends State<Fitti> {
  int _counter = 0;
  List<Workout> workoutContainers = [];

  void _createNewWorkout() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      var foo = Workout(_counter, 50);
      foo.exercises.insert(0, Exercise("butterfly", WorkoutCategory.Shoulders));
      workoutContainers.insert(0, foo);
      _navigateToWorkoutScreen(context, foo);
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
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
                        onTap: () => _navigateToWorkoutScreen(context, workoutContainers[index]),
                      ));
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewWorkout,
        tooltip: 'New Workout',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<dynamic> _navigateToWorkoutScreen(BuildContext context, Workout workout) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutScreen(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: workout,
        ),
      ),
    );
  }
}
