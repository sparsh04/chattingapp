import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_kisan/screens/Splash_screen.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/screens/home_screen.dart';
import 'package:my_kisan/screens/Login_Screen.dart';
import 'package:my_kisan/screens/Maindrawer.dart';
import 'package:my_kisan/screens/Otp_screen.dart';
import 'package:my_kisan/screens/Signup_Screen.dart';
import 'package:my_kisan/screens/home_screen.dart';

class OtpScreen extends StatefulWidget {
  //const OtpScreen({Key? key}) : super(key: key);
  String? verificationid, phonenumber, firstname;
  Map<String, String> userInfoMap;
  OtpScreen(
      this.firstname, this.phonenumber, this.verificationid, this.userInfoMap);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpcontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showloading = false;

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                height: Height / 3,
                width: Width,
                decoration: BoxDecoration(
                    color: whitedark,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(80))),
              ),
              Positioned(
                bottom: 35,
                child: Container(
                  height: Height / 3,
                  width: Width,
                  decoration: BoxDecoration(
                      color: yellowcolor,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(80))),
                ),
              ),
              Positioned(
                bottom: 70,
                child: Container(
                  height: Height / 3,
                  width: Width,
                  decoration: BoxDecoration(
                      color: Color(0xfff35751f),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(80))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Otp",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -380,
                child: Container(
                  margin: EdgeInsets.only(left: 60),
                  height: Height * 0.5,
                  width: Width * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 33,
                            color: Color(0xffd3d3d3).withOpacity(.90))
                      ]),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Column(
                children: [
                  Text(
                    "Otp has been s!ent your register\n Mobile Number",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: Height / 20,
                          width: Width * 0.6 + 10,
                          child: TextFormField(
                            controller: otpcontroller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                labelText: " Enter Otp",
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textcolorgrey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                prefixStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 140,
                  ),
                  MaterialButton(
                    height: Height / 20,
                    minWidth: Width * 0.6 + 10,
                    onPressed: () {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationid!,
                              smsCode: otpcontroller.text);

                      signInwithPhoneCredetial(phoneAuthCredential);
                    },
                    color: Color(0xfffeda704),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signInwithPhoneCredetial(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showloading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.phonenumber)
          .get();

      if (!snapshot.exists && widget.userInfoMap != Null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.phonenumber)
            .set(widget.userInfoMap);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.phonenumber)
            .update({"uid": _auth.currentUser!.uid});

        User? currentuser = _auth.currentUser;
        currentuser!.updatePhoneNumber(phoneAuthCredential);
        currentuser.updateDisplayName(widget.firstname);
        currentuser.updatePhotoURL(widget.userInfoMap['photourl']);
      }

      print(_auth.currentUser!.phoneNumber);

      //    _auth.currentUser.updateDisplayName

      setState(() {
        showloading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showloading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message as String)));
    }
  }
}
