import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:developer' as developer;

import './counter.dart';
import '../scoped_models/workouts.dart';

class AddWorkoutSet extends StatefulWidget {
  final int workoutIndex;
  final int exerciseIndex;

  const AddWorkoutSet(
    this.workoutIndex,
    this.exerciseIndex, {
    required Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddWorkoutSetState();
  }
}

class _AddWorkoutSetState extends State<AddWorkoutSet> {
  late int reps;
  late int weight;
  late int volume;

  @override
  void initState() {
    super.initState();
    reps = 5;
    weight = 50;
    volume = 0;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<WorkoutsModel>(builder: (
      BuildContext context,
      Widget? child, // Make this nullable
      WorkoutsModel model,
    ) {
      return InkWell(
        key: const Key('addWorkoutSetBtn'), // Valid key
        borderRadius: BorderRadius.circular(50.0),
        onTap: () {
          showModal(context).then((update) {
            if (update != null && update) {
              model.addWorkoutSet(
                widget.workoutIndex,
                widget.exerciseIndex,
                reps: reps,
                weight: weight,
                volume: volume,
              );
              developer.log(volume.toString());
            }
          });
        },
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.secondary,
              size: 30.0,
            ),
          ],
        ),
      );
    });
  }

  Future<dynamic> showModal(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            const SizedBox(height: 15.0),
            Counter(
              startingValue: 5,
              onChanged: (value) {
                setState(() {
                  reps = value;
                });
              },
              key: const Key('repsCounter'), // Assigning valid key
            ),
            const SizedBox(height: 20.0),
            Counter(
              startingValue: 50,
              increment: 5,
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
              key: const Key('weightCounter'), // Assigning valid key
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              key: const Key('addSetButton'), // Valid key
              onPressed: () {
                setState(() {
                  volume = volume + weight * reps;
                });
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Add Set'),
            ),
          ],
        );
      },
    );
  }
}
