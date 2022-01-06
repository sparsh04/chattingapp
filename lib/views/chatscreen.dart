import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:chattingapp/services/databse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

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

  Widget chatMessageTile(String message, bool sendby) {
    return Row(
      mainAxisAlignment:
          sendby ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(24),
              bottomRight:
                  sendby ? const Radius.circular(0) : const Radius.circular(24),
              topRight: const Radius.circular(24),
              bottomLeft:
                  sendby ? const Radius.circular(24) : const Radius.circular(0),
            ),
            color: Colors.blueGrey,
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

//use stream whnerver there is change in data and for that use stream

  Widget chatMessages() {
    return StreamBuilder(
        stream: messageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.only(bottom: 70, top: 16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return chatMessageTile(
                        ds["message"], myUserName == ds["sendBy"]);
                  },
                )
              : Center(
                  child: Container(),
                );
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTextEdittingContoller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "type a message",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ),
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
