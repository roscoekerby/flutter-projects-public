import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart'; // Add the logger package

import './app.dart';
import './scoped_models/workouts.dart';
import './scoped_models/exercises.dart';
import './services/workout_service_flutter.dart';
import './services/exercise_service_flutter.dart';

// Initialize logger
final Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures the binding is initialized

  try {
    logger.i("Starting app initialization.");

    // Retrieve the directory asynchronously since it's required for service initialization
    Directory appDir = await getApplicationDocumentsDirectory();
    logger.d("App directory obtained: ${appDir.path}");

    // Initialize services
    var workoutService = WorkoutServiceFlutter(() async => appDir);
    var exercisesService = ExerciseServiceFlutter(() async => appDir);

    logger.d("Services initialized successfully.");

    // Initializing the models with services
    WorkoutsModel workoutsModel = WorkoutsModel(
      workoutService: workoutService,
    );

    ExercisesModel exercisesModel = ExercisesModel(
      exerciseService: exercisesService,
    );

    logger.i("Models initialized successfully.");

    // Run the app with the initialized models
    runApp(App(
      workoutsModel: workoutsModel,
      exercisesModel: exercisesModel,
      key: UniqueKey(),
    ));

    logger.i("App started successfully.");
  } catch (e, stacktrace) {
    // Log the error with stack trace
    logger.e('Error during initialization $e $stacktrace');
  }
}
