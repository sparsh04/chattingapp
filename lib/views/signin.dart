import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/services/databse.dart';
import 'package:chattingapp/views/home.dart';
import 'package:chattingapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  //const Signin({Key? key}) : super(key: key);
  final Function toggle;
  Signin(this.toggle);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Messenger Clone"),
      ),
      body: Center(child: TSIgnIn(widget.toggle)),
    );
  }
}

//the text field box is here
class TSIgnIn extends StatefulWidget {
  final Function toggle;
  // ignore: use_key_in_widget_constructors
  const TSIgnIn(this.toggle);

  @override
  _TSIgnInState createState() => _TSIgnInState();
}

class _TSIgnInState extends State<TSIgnIn> {
  final formKey = GlobalKey<FormState>();
  AuthMedthods authMethods = AuthMedthods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

  signIn() {
    if (formKey.currentState!.validate()) {
      //wrote it myself//check again
      SharedPreferncehelper().saveUserEmail(emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      /// 3/4 --> 51:30 changes made not clear??
      authMethods
          .signInwithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          SharedPreferncehelper.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
        }
      });

      // HelperFunctions.saveUserLoggedInSharedPreference(true);
      // Navigator.pushReplacement(context, MaterialPageRoute(
      //   builder: (context) => ChatRoom()
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height -
            50, // It is used to get rid of the space above in the container and rise below from a height of 50.
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            // mainAxisSize: MainAxisSize
            //   .min, // It means inside this container the contents should be at min(bottom) end.
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please provide a valid emailid";
                        },
                        controller: emailTextEditingController,
                        style: textst(),
                        decoration: textField("email")),
                    TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val!.length > 6
                              ? null
                              : "Please provide more than 6 characters";
                        },
                        controller: passwordTextEditingController,
                        style: textst(),
                        decoration: textField("password")),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Forgot Password?", style: textst()),
                ),
              ),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                    alignment: Alignment
                        .center, //  It centralise the Sign In in the blue box.
                    width: MediaQuery.of(context)
                        .size
                        .width, //  It sets the width of the blue box as the width of the phone.
                    padding: const EdgeInsets.symmetric(
                        vertical:
                            20), //  It gives vertical spacing in the blue box around Sign In button.

                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff007EF4), Color(0xff2A75BC)],
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    )),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  AuthMedthods().signInwithGoogle(context);
                },
                child: Container(
                  alignment: Alignment
                      .center, //  It centralise the Sign In in the blue box.
                  width: MediaQuery.of(context)
                      .size
                      .width, //  It sets the width of the blue box as the width of the phone.
                  padding: const EdgeInsets.symmetric(
                      vertical:
                          20), //  It gives vertical spacing in the blue box around Sign In button.

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text(
                    "Sign In with Google",
                    style: TextStyle(color: Colors.black87, fontSize: 17),
                  ),
                ),
              ),
              //
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                  height: 50), // It is used to give a space of 50 from bottom.
            ],
          ),
        ),
      ),
    );
  }
}
