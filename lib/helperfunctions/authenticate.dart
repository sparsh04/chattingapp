import 'package:chattingapp/views/signin.dart';
import 'package:chattingapp/views/signup.dart';
import 'package:flutter/material.dart';
import "dart:core";

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showIgnIn = true;

  void toggleView() {
    setState(() {
      showIgnIn = !showIgnIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showIgnIn) {
      return Signin(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}
