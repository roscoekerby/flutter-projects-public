import 'package:flutter/material.dart';
import 'package:score_keeper/main.dart';
import 'settings.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
  String _player1Name = "Player 1";
  String _player2Name = "Player 2";
  int _gamesPerSet = 6;
  int _setsToWin = 2;
  bool _isAdvantagePlayed = true;
  bool _allowSuperTiebreak = false;

  int _player1Score = 0; // Current game score for player 1
  int _player2Score = 0; // Current game score for player 2
  int _player1Games = 0; // Number of games won by player 1 in the current set
  int _player2Games = 0; // Number of games won by player 2 in the current set
  int _player1Sets = 0; // Number of sets won by player 1
  int _player2Sets = 0; // Number of sets won by player 2

  bool _player1Advantage = false;
  bool _player2Advantage = false;

  final List<String> _scoreLabels = ['0', '15', '30', '40'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/settings');
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _player1Name = result['player1Name'];
                  _player2Name = result['player2Name'];
                  _gamesPerSet = result['gamesPerSet'];
                  _setsToWin = result['setsToWin'];
                  _isAdvantagePlayed = result['isAdvantagePlayed'];
                  _allowSuperTiebreak = result['allowSuperTiebreak'];
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                playerInformation(playerName: _player1Name),
                playerInformation(playerName: _player2Name),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _player1Score = _player2Score = 0;
      _player1Games = _player2Games = 0;
      _player1Sets = _player2Sets = 0;
      _player1Advantage = _player2Advantage = false;
    });
  }

  void _player1ScorePoint() {
    setState(() {
      _updateScore(playerName: "Player 1");
    });
  }

  void _player2ScorePoint() {
    setState(() {
      _updateScore(playerName: "Player 2");
    });
  }

  void _updateScore({required String playerName}) {
    if (_player1Score == 3 && _player2Score == 3) {
      // Deuce scenario
      if (playerName == "Player 1") {
        if (_player1Advantage) {
          _winGame("Player 1");
        } else if (_player2Advantage) {
          _player2Advantage = false;
        } else {
          _player1Advantage = true;
        }
      } else {
        if (_player2Advantage) {
          _winGame("Player 2");
        } else if (_player1Advantage) {
          _player1Advantage = false;
        } else {
          _player2Advantage = true;
        }
      }
    } else {
      // Normal point progression
      if (playerName == "Player 1") {
        if (_player1Score < 3) {
          _player1Score++;
        } else {
          _winGame("Player 1");
        }
      } else {
        if (_player2Score < 3) {
          _player2Score++;
        } else {
          _winGame("Player 2");
        }
      }
    }
  }

  void _winGame(String winner) {
    setState(() {
      if (winner == "Player 1") {
        _player1Games++;
      } else {
        _player2Games++;
      }
      _player1Score = _player2Score = 0;
      _player1Advantage = _player2Advantage = false;

      if (_player1Games >= _gamesPerSet) {
        _player1Sets++;
        _player1Games = _player2Games = 0;
        _checkMatchWinner("Player 1");
      } else if (_player2Games >= _gamesPerSet) {
        _player2Sets++;
        _player1Games = _player2Games = 0;
        _checkMatchWinner("Player 2");
      }
    });
  }

  void _checkMatchWinner(String player) {
    if (player == "Player 1" && _player1Sets == _setsToWin) {
      _showWinnerDialog(_player1Name);
    } else if (player == "Player 2" && _player2Sets == _setsToWin) {
      _showWinnerDialog(_player2Name);
    }
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("$winner won the match!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _getScoreLabel(String playerName) {
    if (_player1Score == 3 && _player2Score == 3) {
      if (playerName == _player1Name && _player1Advantage) {
        return "Advantage";
      } else if (playerName == _player2Name && _player2Advantage) {
        return "Advantage";
      } else {
        return "Deuce";
      }
    }
    return playerName == _player1Name
        ? _scoreLabels[_player1Score]
        : _scoreLabels[_player2Score];
  }

  Widget playerInformation({required String playerName}) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            // Player Name
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                playerName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),

            // Player Score (15, 30, 40, etc.)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _getScoreLabel(playerName),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 54),
              ),
            ),

            // Player Games
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                playerName == _player1Name
                    ? "Games: $_player1Games"
                    : "Games: $_player2Games",
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),

            // Player Sets
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                playerName == _player1Name
                    ? "Sets: $_player1Sets"
                    : "Sets: $_player2Sets",
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),

            // Score Point Button
            Container(
              margin: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: playerName == _player1Name
                      ? _player1ScorePoint
                      : _player2ScorePoint,
                  child: const Text(
                    "Score Point",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
