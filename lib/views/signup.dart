import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/services/databse.dart';
//import 'package:chattingapp/views/home.dart';
import "dart:core";
import 'package:chattingapp/views/tabs_screen.dart';
import 'package:chattingapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  // ignore: use_key_in_widget_constructors
  const SignUp(this.toggle);

  // const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isloaading = false;
  AuthMedthods authMethods = AuthMedthods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  //HelperFunctions helperFunctions = HelperFunctions();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  signMeUP() async {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": username.text,
        "email": emailcontroller.text,
        "username": username.text,
        "imgUrl":
            "https://www.fortressofsolitude.co.za/wp-content/uploads/2015/09/dragon-ball-z-facts.jpg",
        "status": "Offline",
        "uid": '',
      };

      SharedPreferncehelper().saveUserEmail(emailcontroller.text);
      SharedPreferncehelper().saveUserName(username.text);

      setState(() {
        _isloaading = true;
      });
      authMethods
          .signupwithemailandpassword(
              emailcontroller.text, passwordcontroller.text)
          // ignore: avoid_print
          .then((value) async {
        //print("${value.uid}"));

        userInfoMap['uid'] = FirebaseAuth.instance.currentUser!.uid;

        databaseMethods.uploadUserInfo(userInfoMap);
        SharedPreferncehelper.saveUserLoggedInSharedPreference(true);

        userInfoMap['uid'] = FirebaseAuth.instance.currentUser!.uid;

        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(_auth.currentUser!.uid)
        //     .update(userInfoMap);
        DatabaseMethods().updateusercredentials(
            username.text,
            "https://www.fortressofsolitude.co.za/wp-content/uploads/2015/09/dragon-ball-z-facts.jpg",
            emailcontroller.text,
            passwordcontroller.text);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TabsScreen(0)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Messenger Clone"),
      ),
      body: _isloaading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  //  height: MediaQuery.of(context).size.height - 50,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (val) {
                                return val!.isEmpty || val.length < 4
                                    ? "please provide UserName"
                                    : null;
                              },
                              controller: username,
                              style: textst(),
                              decoration: textField("Username"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please provide a valid UserId";
                              },
                              controller: emailcontroller,
                              style: textst(),
                              decoration: textField("Email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val!.length > 6
                                    ? null
                                    : "provide password with 6 charachter";
                              },
                              controller: passwordcontroller,
                              style: textst(),
                              decoration: textField("Password"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Container(
                      //   alignment: Alignment.centerRight,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 8),
                      //     child: Text(
                      //       "Forget Password",
                      //       style: textst(),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          signMeUP();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff007ef4),
                                Color(0xff2A75bc),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
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
                            "Sign Up with Google",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an accound?",
                            style: TextStyle(
                              color: Colors.white,
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
                                " SignIn Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
