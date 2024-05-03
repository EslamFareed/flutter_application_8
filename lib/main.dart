import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic-Tac-Toe'),
        ),
        body: TicTacToeBoard(),
      ),
    );
  }
}

class TicTacToeBoard extends StatefulWidget {
  @override
  _TicTacToeBoardState createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  List<String> board = List.filled(9, '');
  bool playerTurn = true;
  bool gameOver = false;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (!gameOver && board[index] == '') {
              setState(() {
                board[index] = 'X';
                checkWin();
                if (!gameOver) {
                  aiMove();
                  checkWin();
                }
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(
              child: Text(
                board[index],
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
        );
      },
    );
  }

  void checkWin() {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] != '' &&
          board[condition[0]] == board[condition[1]] &&
          board[condition[0]] == board[condition[2]]) {
        setState(() {
          gameOver = true;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('${board[condition[0]]} Wins!'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      resetGame();
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Play Again'),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        gameOver = true;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Draw!'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    resetGame();
                    Navigator.pop(context);
                  });
                },
                child: Text('Play Again'),
              ),
            ],
          );
        },
      );
    }
  }

  void aiMove() {
    int bestScore = -9999;
    int bestMove = -1;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = minimax(board, 0, false, -9999, 9999);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    board[bestMove] = 'O';
  }

  int minimax(
      List<String> board, int depth, bool isMaximizing, int alpha, int beta) {
    int result = evaluate(board);

    if (result != 0 || depth >= 5) {
      // Adjust the depth for increased difficulty
      return result;
    }

    if (isMaximizing) {
      int bestScore = -9999;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = minimax(board, depth + 1, false, alpha, beta);
          board[i] = '';
          bestScore = max(score, bestScore);
          alpha = max(alpha, score);
          if (beta <= alpha) {
            break;
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 9999;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = minimax(board, depth + 1, true, alpha, beta);
          board[i] = '';
          bestScore = min(score, bestScore);
          beta = min(beta, score);
          if (beta <= alpha) {
            break;
          }
        }
      }
      return bestScore;
    }
  }

  int evaluate(List<String> board) {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] != '' &&
          board[condition[0]] == board[condition[1]] &&
          board[condition[0]] == board[condition[2]]) {
        if (board[condition[0]] == 'O') {
          return 10;
        } else {
          return -10;
        }
      }
    }

    return 0;
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      playerTurn = true;
      gameOver = false;
    });
  }
}
