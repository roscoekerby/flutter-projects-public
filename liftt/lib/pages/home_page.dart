import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/workouts.dart';
import '../scoped_models/exercises.dart';
import '../widgets/workout_calendar.dart';
import '../widgets/exercises.dart';

class HomePage extends StatefulWidget {
  const HomePage({required Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const Center(child: Text('Welcome to LiftT Workout Tracker :)')),
    const WorkoutCalendar(
      key: Key('workoutCalendar'), // Provide a valid key
    ),
    const Exercises(
      key: Key('exercises'), // Provide a valid key
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Load all the data here.
    ScopedModel.of<WorkoutsModel>(context).loadWorkouts();
    ScopedModel.of<ExercisesModel>(context).loadExercises();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget loadingView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiftT Workout Tracker'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget homeView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiftT Workout Tracker'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center_rounded),
          label: 'Exercises',
        ),
      ],
      currentIndex: _selectedIndex,
      fixedColor: Theme.of(context).primaryColor,
      onTap: (i) => _onItemTapped(i),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<WorkoutsModel>(
      builder: (
        BuildContext context,
        Widget? child, // Make child nullable
        WorkoutsModel workoutsModel,
      ) {
        if (workoutsModel.loading) {
          return loadingView();
        } else {
          return homeView();
        }
      },
    );
  }
}
