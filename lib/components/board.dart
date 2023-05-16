import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/components/piece.dart';
import 'package:tetris_game/components/pixel.dart';
import 'package:tetris_game/constant/value.dart';

/*
  GAME BOARD

  This is a 2*2 grid with null representing as empty space.
  A non empty space will have the color to represent the landed pieces

*/

// create game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  // current score
  int currentScore = 0;

  // game over status
  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    // start the game when the app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 400);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          // clear lines
          clearLine();

          // check landing
          checkLanding();

          // check if game is over
          if (gameOver == true) {
            timer.cancel();
            showGameOverDialog();
          }

          // move the piece down
          currentPiece.movePiece(Direction.down);
        });
      },
    );
  }

  // Game over Dialog
  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("GAME OVER"),
        content: Text("Your score is : $currentScore"),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }

  // reset game
  void resetGame() {
    // clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    // new game
    gameOver = false;
    currentScore = 0;

    // create a new piece
    createNewPiece();

    // start game again
    startGame();
  }

  void resetGameButton() {
    // clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    currentScore = 0;
    createNewPiece();
  }

  // check for collision in a future position
  // return true -> there is collision
  // return false -> there is no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      //adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check the piece is out of the bounds (either two low or too far to the left and right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      // Check if the current position is already occupied by another piece in the game board
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    // if no collisions are detected, return false\
    return false;
  }

  // check landing
  void checkLanding() {
    // if going down is occupied
    if (checkCollision(Direction.down)) {
      // then mark the location occupied ong the game board
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      // once landed, create the next piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a random object to generate random tetromino types
    Random rand = Random();

    // create a new piece with random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    /*
      Since our game cover condition is if there is a piece at the top level,
      you want to check if the game is over when you create a new piece 
      instead of checking every frame, because new piece are allowed to go through the top
      level but if there is already a piece in the top level when the new piece is created,
      the game is over.
    */
    if (isGameOver()) {
      gameOver = true;
    }
  }

  // moveLeft
  void moveLeft() {
    // make sure the move is valid before we move that
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // moveRight
  void moveRight() {
    // make sure the move is valid before we move that
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // rotate piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // clear lines
  void clearLine() {
    // step 1: Loop through each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // step 2: Initialize the a variable to track if the row is full
      bool rowIsFull = true;

      // step 3: Check if the row if full (all columns in the row are filled with piece)
      for (int col = 0; col < rowLength; col++) {
        // if there's an empty column, set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // step 4: if the row is full, clear the row and shift rows down
      if (rowIsFull) {
        // step 5: move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          // copy the above row to the current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // step 6: set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        // step 7: Increase the score!
        currentScore++;
      }
    }
  }

  // GAME OVER Function
  bool isGameOver() {
    // check if any columns in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    // if the top row is empty, the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Tetris the Game",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              resetGameButton();
            },
            icon: const Icon(
              Icons.restart_alt_rounded,
              size: 28,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // GAME BOARD
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength),
              itemBuilder: (context, index) {
                // get row and col of each piece
                int row = (index / rowLength).floor();
                int col = index % rowLength;

                // current piece
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: currentPiece.color,
                  );
                }

                // landed piece
                else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(
                    color: tetrominoColors[tetrominoType],
                  );
                }

                // blank pixel
                else {
                  return Pixel(
                    color: Colors.grey[900],
                  );
                }
              },
            ),
          ),

          // DISPLAY SCORE
          Text(
            "Score: $currentScore",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),

          // GAME CONTROLLERS
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // left
                IconButton(
                  onPressed: moveLeft,
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                ),

                // rotate
                IconButton(
                  onPressed: rotatePiece,
                  icon: const Icon(Icons.rotate_right, color: Colors.white),
                ),

                // right
                IconButton(
                  onPressed: moveRight,
                  icon: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
