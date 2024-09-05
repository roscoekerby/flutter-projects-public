import 'package:flutter/material.dart';
import 'screens/cards_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Business Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BusinessCardListScreen(),
    );
  }
}
