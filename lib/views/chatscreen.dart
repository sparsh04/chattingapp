import 'dart:io';

import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:chattingapp/services/databse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  //ChatScreen({Key? key, this.chatWithUsername, this.name}) : super(key: key);
  final String chatWithUsername, name;
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  ChatScreen(this.chatWithUsername, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? chatRoomId, messgaeId = "";
  Stream? messageStream;
  String? myName, myProfilepic, myUserName, myEmail;
  TextEditingController messageTextEdittingContoller = TextEditingController();
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> uploadImage() async {
    String filename = const Uuid().v1();

    int status = 1;

    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(filename)
        .set({
      "sendBy": _auth.currentUser!.email,
      "message": "",
      "type": "img",
      "ts": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$filename.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('chats')
          .doc(filename)
          .delete();

      status = 0;
    });
    String? imageUrl;

    if (status == 1) {
      imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('chats')
          .doc(filename)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  getMyInfoFromSHaredPrefrences() async {
    myName = await SharedPreferncehelper().getDisplayName();
    myProfilepic = await SharedPreferncehelper().getProfileUrl();
    myUserName = await SharedPreferncehelper().getUSerName();
    myEmail = await SharedPreferncehelper().getuseremail();

    chatRoomId = getChatRoomIdByUserNames(widget.chatWithUsername, myUserName!);
  }

  getChatRoomIdByUserNames(String a, String b) {
    if (a.compareTo(b) == 1) {
      // a < b returns -1, 0 if equal, 1 if b<a
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    if (messageTextEdittingContoller.text != "") {
      String message = messageTextEdittingContoller.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilepic,
        "type": "text",
      };

      if (messgaeId == "") {
        messgaeId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messgaeId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastmessagets": lastMessageTs,
          "messagesendBy": myUserName,
        };

        DatabaseMethods()
            .updateLastMessageSend(chatRoomId!, lastMessageInfoMap);

        if (sendClicked) {
          messageTextEdittingContoller.text = "";
          messgaeId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendby, Map<String, dynamic> map,
      BuildContext context) {
    // print(map['message']);
    final size = MediaQuery.of(context).size;

    if (map['type'] != "img") {
      return Row(
        mainAxisAlignment:
            sendby ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(24),
                bottomRight: sendby
                    ? const Radius.circular(0)
                    : const Radius.circular(24),
                topRight: const Radius.circular(24),
                bottomLeft: sendby
                    ? const Radius.circular(24)
                    : const Radius.circular(0),
              ),
              color: sendby ? Colors.blueGrey : Colors.grey,
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    } else
    // if (map['type'] != "img")
    {
      return Container(
        height: size.height / 2.5,
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        alignment: map['sendby'] == _auth.currentUser!.displayName
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ShowImage(
                imageUrl: map['message'],
              ),
            ),
          ),
          child: Container(
            height: size.height / 2.5,
            width: size.width / 2,
            decoration: BoxDecoration(border: Border.all()),
            alignment: map['message'] != "" ? null : Alignment.center,
            child: map['message'] != ""
                ? Image.network(
                    map['message'],
                    fit: BoxFit.cover,
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

//use stream whnerver there is change in data and for that use stream

  Widget chatMessages() {
    return StreamBuilder(
        stream: messageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 70, top: 16),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                Map<String, dynamic> map =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return chatMessageTile(
                    ds["message"], myUserName == ds["sendBy"], map, context);
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  getandsetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSHaredPrefrences();
    getandsetMessages();
  }

  @override
  void initState() {
    // TODO: implement initState
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),

      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              // ignore: avoid_unnecessary_containers
              child: Container(
                color: Colors.black.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTextEdittingContoller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            // alignment: Alignment.topLeft,
                            onPressed: () => getImageg(),
                            icon: const Icon(Icons.photo),
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => getImageC(),
                            icon: const Icon(Icons.photo_camera),
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                          hintText: "Type a Message",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
