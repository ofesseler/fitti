import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitti/screens/workout_screen.dart';
import 'package:fitti/domain/workout.dart';
import 'package:fitti/domain/workout_list_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
// Import dart:io File only on non-web
// ignore: uri_does_not_exist
import 'dart:io' show File;
// Conditional import for web export logic
import 'web_export.dart'
    if (dart.library.html) 'web_export.dart'
    if (dart.library.io) 'stub_export.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WorkoutListModel(),
      child: const Overview(),
    ),
  );
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

class Fitti extends StatelessWidget {
  const Fitti({super.key, required this.title});
  final String title;

  void _createNewWorkout(BuildContext context) {
    final model = Provider.of<WorkoutListModel>(context, listen: false);
    int id = model.workouts.length + 1;
    var foo = Workout(id, 50);
    foo.exercises.insert(0, Exercise("butterfly", WorkoutCategory.Shoulders));
    model.addWorkout(foo);
    _navigateToWorkoutScreen(context, foo);
  }

  Future<void> _exportWorkouts(BuildContext context) async {
    final model = Provider.of<WorkoutListModel>(context, listen: false);
    final jsonString = jsonEncode(model.workouts.map((w) => w.toJson()).toList());
    if (kIsWeb) {
      // Web: Use exportJsonWeb to trigger download
      final bytes = utf8.encode(jsonString);
      await exportJsonWeb(bytes, 'workouts_export.json');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exported as workouts_export.json (check downloads)')),
      );
    } else {
      // Mobile/Desktop: Use File and path_provider
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/workouts_export.json');
      await file.writeAsString(jsonString);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${file.path}')),
      );
    }
  }

  Future<void> _importWorkouts(BuildContext context) async {
    final model = Provider.of<WorkoutListModel>(context, listen: false);
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null && (result.files.single.bytes != null || result.files.single.path != null)) {
      String jsonString;
      if (kIsWeb) {
        jsonString = utf8.decode(result.files.single.bytes!);
      } else {
        final file = File(result.files.single.path!);
        jsonString = await file.readAsString();
      }
      final List<dynamic> jsonList = jsonDecode(jsonString);
      for (var w in jsonList) {
        model.addWorkout(Workout.fromJson(w));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Import successful!')),
      );
    }
  }

  void _navigateToWorkoutScreen(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutScreen(
          workout: workout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_upload),
              tooltip: 'Export Workouts',
              onPressed: () => _exportWorkouts(context),
            ),
            IconButton(
              icon: const Icon(Icons.file_download),
              tooltip: 'Import Workouts',
              onPressed: () => _importWorkouts(context),
            ),
          ],
        ),
        body: Center(
          child: Consumer<WorkoutListModel>(
            builder: (context, model, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have this many workouts so far:',
                ),
                Text(
                  '${model.workouts.length}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: model.workouts.length,
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
                                            model.workouts[index].name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "Date ${model.workouts[index].created}"),
                                          Text(
                                              "Exercises: "+model.workouts[index].exercises.length.toString()),
                                        ]),
                                  ),
                                ),
                                Column(children: [
                                  Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(children: <Widget>[
                                        for (var workout
                                            in model.workouts[index].exercises)
                                          Text(workout.category.name)
                                      ]))
                                ]),
                              ]),
                            ),
                            onTap: () => _navigateToWorkoutScreen(
                                context, model.workouts[index]),
                          ));
                    })
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createNewWorkout(context),
          tooltip: 'New Workout',
          child: const Icon(Icons.add),
        ));
  }
}
