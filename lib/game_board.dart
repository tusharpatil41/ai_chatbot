import 'package:flutter/material.dart';
import '../ai_logic.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<String>> board = List.generate(3, (_) => List.generate(3, (_) => ' '));
  bool xTurn = true;
  String result = '';
  bool isUserTurn = true;

  void resetBoard() {
    setState(() {
      board = List.generate(3, (_) => List.generate(3, (_) => ' '));
      xTurn = true;
      result = '';
      isUserTurn = true;
    });
  }

  void playMove(int i, int j) {
    if (!isUserTurn || board[i][j] != ' ' || result.isNotEmpty) return;

    setState(() {
      board[i][j] = 'X';
      xTurn = false;
      isUserTurn = false;
    });

    if (checkWinner(board, 'X')) {
      setState(() => result = 'You Win 🎉');
      return;
    }

    if (isFull(board)) {
      setState(() => result = 'Draw 🤝');
      return;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      final move = bestMove(board);
      setState(() {
        board[move[0]][move[1]] = 'O';
        xTurn = true;
        isUserTurn = true;
      });

      if (checkWinner(board, 'O')) {
        setState(() => result = 'AI Wins 🤖');
      } else if (isFull(board)) {
        setState(() => result = 'Draw 🤝');
      }
    });
  }

  Widget buildTile(int i, int j) {
    return GestureDetector(
      onTap: () => playMove(i, j),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: board[i][j] == 'X'
              ? Colors.lightBlue.shade100
              : board[i][j] == 'O'
                  ? Colors.red.shade100
                  : Colors.white,
        ),
        child: Center(
          child: Text(
            board[i][j],
            style: TextStyle(
              fontSize: 48,
              color: board[i][j] == 'X' ? Colors.blue : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1,
          child: Column(
            children: List.generate(3, (i) {
              return Expanded(
                child: Row(
                  children: List.generate(3, (j) => Expanded(child: buildTile(i, j))),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          result,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: resetBoard,
          child: const Text('Restart'),
        ),
      ],
    );
  }
}
