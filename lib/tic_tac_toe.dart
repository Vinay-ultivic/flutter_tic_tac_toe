import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < 3; j++)
                    GestureDetector(
                      onTap: () => _onTileTap(i, j),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Center(
                          child: Text(
                            board[i][j],
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _onTileTap(int row, int col) {
    if (board[row][col].isEmpty) {
      // Update the local board
      setState(() {
        board[row][col] = 'X';
      });

      // Update the database
      databaseReference.child('board').set(board);
    }
  }
}




