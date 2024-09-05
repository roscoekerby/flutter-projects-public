import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final _player1Controller = TextEditingController(text: "Player 1");
  final _player2Controller = TextEditingController(text: "Player 2");
  int _gamesPerSet = 6;
  int _setsToWin = 2;
  bool _isAdvantagePlayed = true;
  bool _allowSuperTiebreak = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Player 1 Name
            TextField(
              controller: _player1Controller,
              decoration: const InputDecoration(
                labelText: 'Player 1 Name',
              ),
            ),
            const SizedBox(height: 10),
            // Player 2 Name
            TextField(
              controller: _player2Controller,
              decoration: const InputDecoration(
                labelText: 'Player 2 Name',
              ),
            ),
            const SizedBox(height: 10),
            // Number of Games per Set
            DropdownButtonFormField<int>(
              value: _gamesPerSet,
              decoration: const InputDecoration(labelText: 'Games per Set'),
              items: List.generate(8, (index) => index + 4).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _gamesPerSet = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            // Number of Sets to Win the Match
            DropdownButtonFormField<int>(
              value: _setsToWin,
              decoration: const InputDecoration(labelText: 'Sets to Win Match'),
              items: List.generate(5, (index) => index + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _setsToWin = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            // Advantage Play Toggle
            SwitchListTile(
              title: const Text('Play with Advantage'),
              value: _isAdvantagePlayed,
              onChanged: (bool value) {
                setState(() {
                  _isAdvantagePlayed = value;
                });
              },
            ),
            const SizedBox(height: 10),
            // Super Tiebreak Toggle
            SwitchListTile(
              title: const Text('Allow Super Tiebreak'),
              value: _allowSuperTiebreak,
              onChanged: (bool value) {
                setState(() {
                  _allowSuperTiebreak = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Save Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'player1Name': _player1Controller.text,
                  'player2Name': _player2Controller.text,
                  'gamesPerSet': _gamesPerSet,
                  'setsToWin': _setsToWin,
                  'isAdvantagePlayed': _isAdvantagePlayed,
                  'allowSuperTiebreak': _allowSuperTiebreak,
                });
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
