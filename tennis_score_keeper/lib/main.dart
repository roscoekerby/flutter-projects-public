import 'package:flutter/material.dart';
import 'screens/score_view.dart';
import 'screens/settings.dart';

void main() => runApp(const MyApp());

const String appName = "Tennis Score Tracker";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Game(),
      routes: {
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
