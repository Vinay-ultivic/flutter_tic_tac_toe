import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tic_tac/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BoardScreen extends StatefulWidget {
  String player1;
  String player2;
  BoardScreen({Key? key, required this.player1, required this.player2})
      : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

late List<List<String>> _board;
late String _currentPlayer;
late String _winner;
late bool _gameOver;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    super.initState();
    _loadGameState();
    _board = List.generate(3, (_) => List.generate(3,(_)=>""));
    _currentPlayer="X";
    _winner="";
    _gameOver= false;
  }

  Future<void> _loadGameState() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document =
      await _firestore.collection('games').doc(_getGameId()).get();
      Map<String, dynamic> data = document.data() ?? {};

      setState(() {
        _board = List.from(data['board'] ?? List.generate(3, (_) => List.generate(3, (_) => "")));
        _currentPlayer = data['currentPlayer'] ?? "X";
        _winner = data['winner'] ?? "";
        _gameOver = data['gameOver'] ?? false;
      });
    } catch (e) {
      print("Error loading game state from Firestore: $e");
    }
  }

  String _getGameId() {
    return widget.player1 + widget.player2;
  }
  var id= DateTime.now().microsecondsSinceEpoch.toString();
  void _updateFirestore() async {
    try {
      await _firestore.collection('games').doc(id).set({
        "board" : _board
      });
    } catch (e) {
      print("Error updating Firestore: $e");
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      _currentPlayer = "X";
      _winner = "";
      _gameOver = false;

      // Update Firestore
      _updateFirestore();
    });
  }

  void makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }

    setState(() {
      _board[row][col] = _currentPlayer;

      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][2] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][0] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      }

      _currentPlayer = _currentPlayer == "X" ? "O" : "X";

      if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It's a Tie";
      }

      if (_winner != "") {
        // Show dialog and reset game
        _showGameResultDialog();
      }

      // Update Firestore
      _updateFirestore();
    });
  }

  void _showGameResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_winner == "X"
            ? "${widget.player1} Won!"
            : _winner == "O"
            ? "${widget.player2} Won!"
            : "It's a Tie"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Your existing UI code remains the same
    // ...
    var size=MediaQuery.of(context).size;
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey,
        actions: [
          Row(children: [
            const Text("Logout",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red,),),
            IconButton(
                onPressed: (){

                },
                icon: const Icon(Icons.logout,color: Colors.black,))
          ],)

        ],),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              SizedBox(height:90 ,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Turn: ",style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                        Text(
                          _currentPlayer == "X" ? widget.player1 + "  -  ($_currentPlayer)":
                          widget.player2 + "  -  ($_currentPlayer)",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: _currentPlayer == "X" ? Colors.pinkAccent: Colors.greenAccent,
                          ),),
                      ],
                    ),
                    SizedBox(height: 20),

                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(5),

                child: GridView.builder(
                  itemCount: 9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                  ), itemBuilder: (context, index) {
                  int row = index ~/3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => makeMove(row, col),
                    child: Container(alignment: Alignment.center,
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_board[row][col],style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: _board[row][col] == "X" ? Colors.pinkAccent : Colors.greenAccent,
                      ),),
                    ),
                  );
                },),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*      InkWell(
                    onTap: _resetGame,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18 ,horizontal:20 ),
                      child: const Text("Reset Game",style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,

                      ),),
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(

                      height: size.height/17,
                      width: size.width/2.5,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          elevation: 8,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),

                          ),
                          backgroundColor:Colors.black54,
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                        ),
                        onPressed: () {

                          _resetGame();

                        },
                        child:  const Text('RESET GAME',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1,fontSize: 15),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(

                      height: size.height/17,
                      width: size.width/2.6,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          elevation: 8,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),

                          ),
                          backgroundColor:Colors.black54,
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                        ),
                        onPressed: () {

                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  WelcomeScreen(),

                          ));
                          widget.player1= "";
                          widget.player2= "";

                        },
                        child:  const Text('RESTART',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1,fontSize: 15),),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          )
      ),

    );
  }
}