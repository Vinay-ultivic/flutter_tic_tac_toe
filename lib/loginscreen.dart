import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tic_tac/signupscreen.dart';
import 'package:firebase_tic_tac/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey=  GlobalKey<FormState>();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passController=TextEditingController();
  bool loading=false;
  bool passWord=false;

  RegExp regPass= RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  RegExp regEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Login here",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),)
                  ],),
                const Padding(
                  padding: EdgeInsets.only(left: 22,top: 20),
                  child: Text("E-Mail",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Colors.black,letterSpacing: 0.5),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 5 ),
                  child:TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder(),
                      hintText: 'Enter email',
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Please enter the email";
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 22,top: 20),
                  child: Text("Password",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Colors.black,letterSpacing: 0.5),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 10 ),
                  child:TextFormField(
                    obscureText: !passWord,
                    controller: passController,
                    decoration:  InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                            passWord
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black
                        ),
                        onPressed: () {

                          setState(() {
                            passWord = !passWord;
                          });
                        },
                      ),
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Please enter the password";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
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
                            if(emailController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Enter email"),
                              ));
                            }
                            else if(passController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Enter Password"),
                              ));
                            }
                            else if (!regEmail.hasMatch(emailController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Enter valid Email'),
                              ));
                            }
                            else if (!regPass.hasMatch(passController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Enter Strong password'),
                              ));
                            }
                            else{
                              _login();

                            }


                          },
                          child:  const Text('LOGIN',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1,fontSize: 15),),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text:  TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            recognizer:TapGestureRecognizer()..onTap=(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                            } ,
                            text: "Sign up here",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )

              ],),
          ),
        ),

        Visibility(
            visible: loading,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            )),
      ],
    );
  }


  Future<void> _login() async {
    loading=true;
    setState(() {

    });
    try {

      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      // Login successful
      print("Login successful");
      emailController.clear();
      passController.clear();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()));

      loading=false;
    } catch (e) {
      // Handle login errors
      print("Error during login: $e");
      emailController.clear();
      passController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid Credentials"),

      ));
      loading=false;
      setState(() {
      });
    }
  }


}
