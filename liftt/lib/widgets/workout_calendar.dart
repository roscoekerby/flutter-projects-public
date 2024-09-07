import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/workout.dart';
import '../scoped_models/workouts.dart';

import '../widgets/event_calendar/event_calendar.dart';

// Make the class public by removing the underscore
class WorkoutCalendar extends StatefulWidget {
  const WorkoutCalendar({required Key key}) : super(key: key);

  @override
  WorkoutCalendarState createState() => WorkoutCalendarState();
}

// Also make this class public
class WorkoutCalendarState extends State<WorkoutCalendar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: ScopedModelDescendant<WorkoutsModel>(
        builder: (
          BuildContext context,
          Widget? child, // Change to Widget? to match the expected signature
          WorkoutsModel model,
        ) {
          List<DateTime> markedDates = model.workouts.map((Workout workout) {
            return workout.date;
          }).toList();

          // Ensure the EventCalendar widget is defined or imported from a package
          return EventCalendar(
            markedDates: markedDates,
            onDateSelected: (DateTime date) {
              final year = date.year;
              final month = date.month;
              final day = date.day;

              Navigator.pushNamed(context, '/workouts/$year/$month/$day');
            },
            key: const Key('eventCalendar'), // Assign a valid key
            date: DateTime.now(), // Ensure `date` is provided
          );
        },
      ),
    );
  }
}
