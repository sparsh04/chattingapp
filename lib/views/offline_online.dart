import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class allChats extends StatefulWidget {
  const allChats({Key? key}) : super(key: key);

  @override
  _allChatsState createState() => _allChatsState();
}

class _allChatsState extends State<allChats> {
  //List<String> uid = [];
  @override
  void initState() {
    super.initState();
    //uid.removeRange(0, uid.length);

    //     value.docs.forEach((element) {
    //       print(element);
    //       if (element['uid'] != FirebaseAuth.instance.currentUser!.uid)
    //         uid.add(element['uid']);
    //     });
    //   });
    //   print(uid);
    // }
  }

  @override
  Widget build(BuildContext context) {
    //print(uid);
    return Container(
        height: 30,
        child: StreamBuilder<QuerySnapshot>(
            builder: (context, snapshot) {
              if(snapshot.connectionState!=ConnectionState.done){
                return CircularProgressIndicator();
              }
              List<String> uid = [];
              //snapshot.data!.docs.
              snapshot.data!.docs.forEach((element) {
                Map<String,dynamic> d = element.data() as Map<String,dynamic>;
                if(d.containsKey('uid')) {
                  uid.add(d['uid']);
                }
              });
              print(uid);
              return ListView.builder(itemBuilder: (context,index){
                return statusUpdate(uid: uid[index]);
              },
                itemCount: uid.length,
              );
            },
            stream:
                FirebaseFirestore.instance.collection('users').get().asStream())
        //return statusUpdate(uid: uid[index]);

        //itemCount: uid.length,
        );
  }
}

class statusUpdate extends StatefulWidget {
  final String uid;
  statusUpdate({required this.uid});

  @override
  _statusUpdateState createState() => _statusUpdateState();
}

class _statusUpdateState extends State<statusUpdate> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection("users").doc(widget.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: Text("${snapshot.data!['uid']}"),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
