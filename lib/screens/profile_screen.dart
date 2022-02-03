import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_kisan/constant.dart';

import '../size_config.dart';

class ProfileScreen extends StatefulWidget {
  static String RouteName = "/ProfileScreen";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var name, address1, address2, pincode, state;

  @override
  void initState() {
    getuser();
    getprofile();
    super.initState();
  }

  Future<dynamic> getuser() async {
    final userdoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .get();

    final userdata = userdoc.data();
    print(userdata);

    name = userdata!['name'];

    return userdata;
  }

  getprofile() async {
    var data = await getuser();
    var name = await data['name'];
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              height: screenHeight(context) / 20,
              width: screenWidth(context),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: InputBorder.none,
                  hintText: name,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: screenHeight(context) / 20,
              width: screenWidth(context),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Address1",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: screenHeight(context) / 20,
              width: screenWidth(context),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Address2",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: screenHeight(context) / 20,
              width: screenWidth(context),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: InputBorder.none,
                  hintText: "pincode",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              height: screenHeight(context) / 20,
              width: screenWidth(context),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: InputBorder.none,
                  hintText: "State",
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            MaterialButton(
              height: screenHeight(context) / 22,
              minWidth: screenWidth(context) * 0.8,
              onPressed: () {},
              color: Color(0xfffeda704),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
