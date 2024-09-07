import 'package:flutter/material.dart';

import '../models/exercise.dart';

class ExerciseListModal {
  static Future<Exercise?> showListModal(
    BuildContext context,
    List<dynamic> items,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                key: Key('listItem$index'),
                title: Text(
                  // Assuming each item has a 'name' property.
                  items[index].name,
                  style: const TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  Navigator.pop(context, items[index]);
                },
              );
            },
            itemCount: items.length,
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        return value as Exercise; // Cast only if value is not null
      }
      return null; // Return null if no value was selected
    });
  }
}
