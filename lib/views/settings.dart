// ignore_for_file: camel_case_types

import 'dart:io';
import "dart:core";
import 'package:chattingapp/feedbackwithslider/feedbackslider.dart';
import 'package:chattingapp/helperfunctions/authenticate.dart';
import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/services/databse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? name = '', username = '', status = '';
  var profilePicUrl = '';
  var imageUrl = '';
  // ignore: prefer_typing_uninitialized_variables
  var photo;

  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController bugseditingcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPhoto();
    // doThisOnLaunch();
    setStatus("Online");
  }

  void getPhoto() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  String inputData() {
    final User? user = _auth.currentUser;
    //print(user!.providerData.toString());
    String provider = user!.providerData[0].providerId;
    return provider;
  }

  void setStatus(String status) async {
    DatabaseMethods().updatestatus(status, _auth.currentUser!.uid);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  Future getImageC() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.camera).then((xfile) {
      if (xfile != null) {
        imageFile = File(xfile.path);
        uploadImage();
      }
    });
  }

  Future getImageg() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xfile) {
      if (xfile != null) {
        imageFile = File(xfile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String filename = const Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$filename.jpg");

    var uploadTask = await ref.putFile(imageFile!);
    //String? imageUrl;

    var imageUrl = await uploadTask.ref.getDownloadURL();

    // print(imageUrl);
    //print(_auth.currentUser!.photoURL);
    updateimg(imageUrl);

    setState(() {
      imageUrl = imageUrl;
    });

    //Navigator.pop(context);
  }

  void updateimg(String img) async {
    DatabaseMethods().updateimage(img, _auth.currentUser!.uid);
  }

  // User? user = _auth.currentUser;

  // getMyInfoFromSHaredPrefrences() async {
  //   name = await SharedPreferncehelper().getDisplayName();
  //   profilePicUrl = (await SharedPreferncehelper().getProfileUrl())!;
  // }

  // doThisOnLaunch() async {
  //   await getMyInfoFromSHaredPrefrences();
  // }

//FirebaseAuth _auth = FirebaseAuth.instance;

  submitbugreport() {
    Map<String, dynamic> bugmap = {
      "sendBy": _auth.currentUser!.displayName,
      "bug": bugseditingcontroller.text,
    };

    DatabaseMethods().submitthebug(_auth.currentUser!.uid, bugmap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          Container(
            // decoration: BoxDecoration(
            //     border: Border.all(), borderRadius: BorderRadius.circular(10)),
            height: 120,
            padding: const EdgeInsets.fromLTRB(10, 28, 10, 0),
            child: Container(
              // decoration: BoxDecoration(
              //     border: Border.all(),
              //     borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  const Divider(
                    color: Colors.black,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 12,
                        // height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          _auth.currentUser!.photoURL != null
                              ? _auth.currentUser!.photoURL as String
                              : "https://www.fortressofsolitude.co.za/wp-content/uploads/2015/09/dragon-ball-z-facts.jpg",
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_auth.currentUser!.displayName as String),
                          Text(_auth.currentUser!.email as String),
                        ],
                      ),
                      // const SizedBox(
                      //   width: 8,
                      // ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 16,
                      child: SizedBox(
                        height: 200,
                        // decoration: BoxDecoration(
                        //   border: Border.all(),
                        // ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Choose your Destination",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // const Divider(
                            //   color: Colors.black,
                            // ),
                            GestureDetector(
                              onTap: () async {
                                await getImageC();
                                Navigator.pop(context);
                              },
                              child: Container(
                                // margin: EdgeInsets.all(20),
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    // const SizedBox(height: 20),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.camera,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("Camera"),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // const Divider(
                            //   color: Colors.black,
                            // ),
                            const SizedBox(
                              height: 22,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await getImageg();
                                Navigator.pop(context);
                              },
                              child: Container(
                                // margin: EdgeInsets.all(20),
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.album,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("Gallery"),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // const Divider(
                            //   color: Colors.black,
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                )),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: const texttype("Update DisplayImage", Icons.photo),
          ),
          GestureDetector(
            child: const texttype("BugReport", Icons.bug_report_outlined),
            onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 16,
                    child: SizedBox(
                      height: 250,
                      // decoration: BoxDecoration(
                      //   border: Border.all(),
                      // ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(Icons.bug_report_sharp),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Submit Bugreport",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, spreadRadius: 1),
                              ],
                            ),
                            height: 100,
                            child: TextField(
                              controller: bugseditingcontroller,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              minLines: null,
                              maxLines:
                                  null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                              expands: true,
                              decoration:
                                  const InputDecoration(contentPadding: null),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    )),
                                const SizedBox(
                                  width: 8,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      submitbugreport();
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            'Bugreport submitted Submitted'),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );

                                      // Find the ScaffoldMessenger in the widget tree
                                      // and use it to show a SnackBar.
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          //feedback report
          GestureDetector(
            child: const texttype("Feedback", Icons.feedback),
            onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 16,
                    child: SizedBox(
                      height: 440,
                      // decoration: BoxDecoration(
                      //   border: Border.all(),
                      // ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(Icons.feedback),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Submit Feedback",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),

                          const FeedbackSlider(),
                          // Container(
                          //   margin: const EdgeInsets.symmetric(horizontal: 20),

                          // ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          GestureDetector(
            child: const texttype("Logout", Icons.logout),
            onTap: () {
              setStatus("Offline");
              if (inputData() == "google.com") {
                AuthMedthods().signOut().then((s) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Authenticate(),
                    ),
                  );
                });
              } else {
                AuthMedthods().tsignOut().then((s) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Authenticate(),
                    ),
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class texttype extends StatelessWidget {
  // const texttype({
  //   Key? key,
  // }) : super(key: key);
  final String material;
  final IconData photo;
  // ignore: use_key_in_widget_constructors
  const texttype(this.material, this.photo);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     border: Border.all(), borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const Divider(
            color: Colors.black,
          ),
          Row(
            children: [
              Icon(
                photo,
                color: Colors.blue,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(material),
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
