import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:chattingapp/services/databse.dart';
import 'package:chattingapp/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMedthods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  signInwithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIN = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIN.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    UserCredential? userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = userCredential.user;

    SharedPreferncehelper().saveUserEmail(userDetails?.email);
    SharedPreferncehelper().saveUserId(userDetails?.uid);
    SharedPreferncehelper()
        .saveUserName(userDetails?.email!.replaceAll("@gmail.com", ""));
    SharedPreferncehelper().saveDisplayName(userDetails?.displayName);
    SharedPreferncehelper().saveProfileName(userDetails?.photoURL);

    Map<String, dynamic> userInfoMap = {
      "email": userDetails?.email,
      "username": userDetails?.email!.replaceAll("@gmail.com", ""),
      "name": userDetails?.displayName,
      "imgUrl": userDetails?.photoURL,
      "status": "offline",
      "uid": userDetails?.uid,
    };

    DatabaseMethods()
        .addUserInfoToDb(userDetails!.uid, userInfoMap)
        .then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    });
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    final _googleSignIn = GoogleSignIn();

    await _googleSignIn.disconnect();
    await auth.signOut();
  }
}
