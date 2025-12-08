List<List<String>> cloneBoard(List<List<String>> board) =>
    board.map((row) => List<String>.from(row)).toList();

bool isFull(List<List<String>> board) =>
    board.every((row) => row.every((cell) => cell != ' '));

bool checkWinner(List<List<String>> board, String player) {
  for (var i = 0; i < 3; i++) {
    if (board[i].every((cell) => cell == player)) return true;
    if (board.every((row) => row[i] == player)) return true;
  }
  return (board[0][0] == player && board[1][1] == player && board[2][2] == player) ||
      (board[0][2] == player && board[1][1] == player && board[2][0] == player);
}

int minimax(List<List<String>> board, bool isMaximizing) {
  if (checkWinner(board, 'O')) return 1;
  if (checkWinner(board, 'X')) return -1;
  if (isFull(board)) return 0;

  int bestScore = isMaximizing ? -999 : 999;

  for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 3; j++) {
      if (board[i][j] == ' ') {
        board[i][j] = isMaximizing ? 'O' : 'X';
        int score = minimax(board, !isMaximizing);
        board[i][j] = ' ';
        bestScore = isMaximizing ? (score > bestScore ? score : bestScore)
                                 : (score < bestScore ? score : bestScore);
      }
    }
  }

  return bestScore;
}

List<int> bestMove(List<List<String>> board) {
  int bestScore = -999;
  List<int> move = [0, 0];

  for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 3; j++) {
      if (board[i][j] == ' ') {
        board[i][j] = 'O';
        int score = minimax(board, false);
        board[i][j] = ' ';
        if (score > bestScore) {
          bestScore = score;
          move = [i, j];
        }
      }
    }
  }

  return move;
}
