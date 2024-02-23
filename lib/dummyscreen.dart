import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tic_tac/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loginscreen.dart';


class ScreenTic extends StatefulWidget {
  String player1;
  String player2;
  ScreenTic({Key? key, required this.player1, required this.player2})
      : super(key: key);

  @override
  State<ScreenTic> createState() => _ScreenTicState();
}

late List<List<String>> _board;
late String _currentPlayer;
late String _winner;
late bool _gameOver;

final databaseReference = FirebaseDatabase.instance.ref();
final FirebaseAuth _auth = FirebaseAuth.instance;

User? user = FirebaseAuth.instance.currentUser;
String uid = user?.uid ?? '';
final TextEditingController player1Controller=TextEditingController();
final TextEditingController player2Controller=TextEditingController();


class _ScreenTicState extends State<ScreenTic> {
  @override
  void initState() {
    super.initState();

    _board = List.generate(3, (_) => List.generate(3,(_)=>""));
    _currentPlayer="X";
    _winner="";
    _gameOver= false;
  }

  var id= DateTime.now().microsecondsSinceEpoch.toString();

  void dataSave() async {
    try {
      databaseReference.child("games").child(uid).set(_board);
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

     dataSave();
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

      if (!_board.any((row) => row.any((cell) => cell == "")))                 {
        _gameOver = true;

        _winner = "It's a Tie";
      }

      if (_winner != "") {
        // Show dialog and reset game
        _showGameResultDialog();
      }
      dataSave();
    });
  }

  void _showGameResultDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
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
              child: const Text("Play Again"),
            ),
          ],
        ),
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Your existing UI code remains the same
    // ...
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        leading: IconButton(onPressed:(){
          Navigator.pop(context);

           widget.player1= "";
           widget.player2= "";

        } ,icon: Icon(Icons.arrow_back),),
        actions: [
          Row(
            children: [
              const Text("Logout",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red,),),
              IconButton(
                  onPressed: (){
                    _logout();
                  },
                  icon: const Icon(Icons.logout,color: Colors.black,))
            ],),

        ],),

      backgroundColor: Colors.white
      ,
      body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              SizedBox(height:90 ,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Turn: ",style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                        ),
                        Text(
                          _currentPlayer == "X" ? " ${widget.player1} - ($_currentPlayer)": " ${widget.player2} - ($_currentPlayer)",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: _currentPlayer == "X" ? Colors.pinkAccent: Colors.greenAccent,
                          ),),
                      ],
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),

                child: GridView.builder(
                  itemCount: 9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,),
                  itemBuilder: (context, index) {

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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(

                      height: size.height/17,
                      width: size.width/2.4,

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

                          Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
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
  Future<void> _logout() async {
    try {
      await _auth.signOut();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    } catch (e) {

      print("Error during logout: $e");
    }
  }
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Exit Game'),
          content: const Text('Do you want to exit a Game'),
          actions:[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    textStyle: TextStyle(color: Colors.blue),

                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child:Text('No'),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      textStyle: TextStyle(color: Colors.blue)
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child:Text('Yes'),
                ),
              ],)


          ],
        );
      }
    )??false; //if showDialouge had returned null, then return false
  }
}