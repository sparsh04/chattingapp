import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/size_config.dart';

class NotificationScreen extends StatefulWidget {
  static String routName = "/NotificationScreen";
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var notificationstream;

  getNotifications() async {
    //messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    notificationstream = await getuserNotifications();
    setState(() {});
  }

  doThisOnLaunch() async {
    await getNotifications();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();
    doThisOnLaunch();
    super.initState();
  }

  Future<Stream<QuerySnapshot>> getuserNotifications() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.phoneNumber)
        .collection("Notifications")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Column(children: [
        StreamBuilder(
          stream: notificationstream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot? ds = snapshot.data.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: screenHeight(context) / 6,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              color: orangecolor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          // color: orangecolor.withOpacity(0.3),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text("Dear User \n\n"),
                              Text(ds!['Title']),
                              Text(ds['subtitle']),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ]),
    );
  }
}
