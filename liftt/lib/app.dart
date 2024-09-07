import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './scoped_models/exercises.dart';
import './pages/workouts_page.dart';
import './router_param_parser.dart';
import './scoped_models/workouts.dart';
import './pages/home_page.dart';
import './pages/add_exercise_page.dart';

class App extends StatelessWidget {
  final WorkoutsModel workoutsModel;
  final ExercisesModel exercisesModel;

  const App({
    required Key key,
    required this.workoutsModel,
    required this.exercisesModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homePage = ScopedModel<ExercisesModel>(
      model: exercisesModel,
      child:
          const HomePage(key: Key('homePageKey')), // Assign a valid unique Key
    );

    final addExercisePage = ScopedModel<ExercisesModel>(
      model: exercisesModel,
      child: const AddExercisePage(
          key: Key('addExercisePageKey')), // Assign a valid unique Key
    );

    final app = MaterialApp(
      title: 'LiftT Workout Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.red),
      ),
      routes: {
        '/': (BuildContext context) => homePage,
        '/addExercise': (BuildContext context) => addExercisePage,
      },
      onGenerateRoute: (RouteSettings settings) => _parseRouteParams(
        settings,
        exercisesModel,
      ),
    );

    return ScopedModel<WorkoutsModel>(
      model: workoutsModel,
      child: app,
    );
  }

  Route<dynamic>? _parseRouteParams(
    RouteSettings settings,
    ExercisesModel exercisesModel,
  ) {
    String workoutsPageRouteName = 'workouts';
    RouterParamParser parser = RouterParamParser([
      workoutsPageRouteName,
    ]);
    ParsedRoute? route = parser.parse(settings);

    if (route?.name == workoutsPageRouteName) {
      final int year = int.parse(route?.params[0]);
      final int month = int.parse(route?.params[1]);
      final int day = int.parse(route?.params[2]);

      return MaterialPageRoute<bool>(
        builder: (BuildContext context) => ScopedModel<ExercisesModel>(
          model: exercisesModel,
          child: WorkoutsPage(
            year: year,
            month: month,
            day: day,
            key: const Key('workoutsPageKey'), // Assign a valid unique Key
          ),
        ),
      );
    }

    return null;
  }
}
