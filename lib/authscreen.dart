import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tic_tac/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loginscreen.dart';


class AuthScr extends StatefulWidget {
  const AuthScr({super.key});

  @override
  State<AuthScr> createState() => _AuthScrState();
}

class _AuthScrState extends State<AuthScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context ,AsyncSnapshot<User?> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              log("<<<<<<-------Loading----->>>>");
              return  const Center(child: Text("Loading......."));
            }
            if(snapshot.hasData){
              return const WelcomeScreen();
            }
            else{
              return const LoginScreen();
            }
          }
      ),
    );
  }
}