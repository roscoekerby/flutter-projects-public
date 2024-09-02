import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  TicTacToeGameState createState() => TicTacToeGameState();
}

class TicTacToeGameState extends State<TicTacToeGame> {
  late List<String> board;
  late String currentPlayer;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameOver = false;
    });
  }

  void makeMove(int index) {
    if (!gameOver && board[index] == '') {
      setState(() {
        board[index] = currentPlayer;
        if (checkWin(currentPlayer)) {
          gameOver = true;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Game Over"),
              content: Text("$currentPlayer wins!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: const Text('Play Again'),
                ),
              ],
            ),
          );
        } else if (board.every((cell) => cell != '')) {
          gameOver = true;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Game Over"),
              content: const Text("It's a Draw!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: const Text('Play Again'),
                ),
              ],
            ),
          );
        } else {
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWin(String player) {
    for (var winCombo in winningCombos) {
      if (board[winCombo[0]] == player &&
          board[winCombo[1]] == player &&
          board[winCombo[2]] == player) {
        return true;
      }
    }
    return false;
  }

  final List<List<int>> winningCombos = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      makeMove(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetGame,
                child: const Text('Reset Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
