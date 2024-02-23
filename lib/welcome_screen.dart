import 'package:firebase_tic_tac/dummyscreen.dart';
import 'package:flutter/material.dart';
import 'board_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {


  final GlobalKey<FormState> formKey=  GlobalKey<FormState>();
  final TextEditingController player1Controller=TextEditingController();
  final TextEditingController player2Controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150,),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(72),
                    image:  const DecorationImage(image: AssetImage("assets/images/tic.png"),fit: BoxFit.cover)
                ),
                /*  child: Image.asset("assets/images/tic.png"),*/
              ),
              const SizedBox(height: 10,),
              const Text("Enter Players Name",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 5 ),
                child: TextFormField(
                  maxLength: 10,
                  controller: player1Controller,
                  decoration: const InputDecoration(
                    counterText: '',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    border: OutlineInputBorder(),
                    hintText: "Player1Name",

                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return "Please enter the Player1name";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                child: TextFormField(
                  maxLength: 10,
                  controller: player2Controller,
                  decoration: const InputDecoration(
                    counterText: '',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    border: OutlineInputBorder(),
                    hintText: "Player2Name",

                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return "Please enter the Player2name";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.only(left: 23,right: 23,top: 10),
                child: SizedBox(

                  height: size.height/19,
                  width: size.width/3,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      elevation: 8,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),

                      ),
                      backgroundColor:Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal),
                    ),
                    onPressed: () {
                      if(player1Controller.text.trim().isNotEmpty && player2Controller.text.trim().isNotEmpty){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> ScreenTic(player1: player1Controller.text.trim(),player2: player2Controller.text.trim(),)));
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(" Players name is empty"),
                        ));
                      }


                    },
                    child:  const Text('START',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1,fontSize: 15),),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Exit Game'),
        content: Text('Do you want to exit a Game'),
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
      ),
    )??false; //if showDialouge had returned null, then return false
  }
}
