import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/services/databse.dart';
import 'package:chattingapp/views/chatscreen.dart';
import 'package:chattingapp/views/offline_online.dart';
import 'package:chattingapp/views/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool issearching = false;
  String? myName, myProfilepic, myUserName, myEmail;

  Stream? userStream, chatRoomStream;

  TextEditingController searchUsernameeditingcontroller =
      TextEditingController();

  getMyInfoFromSHaredPrefrences() async {
    myName = await SharedPreferncehelper().getDisplayName();
    myProfilepic = await SharedPreferncehelper().getProfileUrl();
    myUserName = await SharedPreferncehelper().getUSerName();
    myEmail = await SharedPreferncehelper().getuseremail();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    onScreenloaded();
  }

  void setStatus(String status) async {
    DatabaseMethods().updatestatus(status, _auth.currentUser!.uid);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  getChatRoomIdByUserNames(String a, String b) {
    if (a.compareTo(b) == 1) {
      // a < b returns -1, 0 if equal, 1 if b<a
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnCLick() async {
    issearching = true;
    setState(() {});
    userStream = await DatabaseMethods()
        .getUserByName(searchUsernameeditingcontroller.text);
    setState(() {});
  }

  Widget searchListUsertile({username, profileUrl, name, email}) {
    return GestureDetector(
      onTap: () {
        var chatroomid = getChatRoomIdByUserNames(myUserName!, username);

        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, username]
        };

        DatabaseMethods().createChatRoom(chatroomid, chatRoomInfoMap);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(username, name),
          ),
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              profileUrl,
              height: 30,
              width: 30,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(email),
            ],
          )
        ],
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder<dynamic>(
        stream: userStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return searchListUsertile(
                        username: ds["username"],
                        profileUrl: ds["imgUrl"],
                        name: ds["name"],
                        email: ds["email"]);
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget chatRoomsList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  //always use shwrink wrap with streambuilder
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return ChatRoomListTile(
                        ds.id, ds["lastMessage"], myUserName!);
                  })
              : Container();
        });
  }

  getChatRooms() async {
    chatRoomStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenloaded() async {
    await getMyInfoFromSHaredPrefrences();
    getChatRooms();
  }

  //used above
  // @override
  // void initState() {
  //   onScreenloaded();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenger Clone"),
        actions: [
          InkWell(
            onTap: () {
              AuthMedthods().signOut().then((s) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Signin(),
                  ),
                );
              });
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.exit_to_app_rounded)),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                issearching
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            issearching = false;
                            searchUsernameeditingcontroller.text = "";
                          });
                        },
                        child: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.arrow_back,
                            )))
                    : Container(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                issearching = false;
                              });
                            },
                            child: TextField(
                              controller: searchUsernameeditingcontroller,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "username"),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (searchUsernameeditingcontroller.text != "") {
                              onSearchBtnCLick();
                            }
                          },
                          child: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            issearching ? searchUsersList() : chatRoomsList(),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ChatRoomListTile extends StatefulWidget {
  // ChatRoomListTile({Key? key}) : super(key: key);
  final String lastmessage, chatroomid, mysername;
  // ignore: use_key_in_widget_constructors
  const ChatRoomListTile(this.chatroomid, this.lastmessage, this.mysername);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String? profilePicUrl = "", name = "", username = "", status = "";

  Future getThisUserInfo() async {
    username =
        widget.chatroomid.replaceAll(widget.mysername, "").replaceAll("_", "");
    QuerySnapshot<Object?> querySnapshot =
        await DatabaseMethods().getUserInfo(username);
    //  print(username);
    // print(widget.chatroomid);
    // print("a0");
    name = await querySnapshot.docs[0]["name"];
    profilePicUrl = await querySnapshot.docs[0]["imgUrl"];
    status = await querySnapshot.docs[0]["status"];

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    //_user
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(profilePicUrl);
    //  String? _user = FirebaseAuth.instance.currentUser?.photoURL;
    //FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return allChats();
    // return Flexible(
    //   child: Row(
    //     children: [
    //       GestureDetector(
    //         onTap: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => ChatScreen(username!, name!),
    //             ),
    //           );
    //         },
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(32),
    //           child: Image.network(
    //             profilePicUrl!,
    //             height: 30,
    //             width: 30,
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         width: 12,
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(height: 40, child: allChats()),
    //           Text(
    //             name!,
    //             style: const TextStyle(fontSize: 16),
    //           ),
    //           const SizedBox(
    //             height: 3,
    //           ),
    //           Text(widget.lastmessage),
    //         ],
    //       ),
    //       // Container(
    //       //   decoration: BoxDecoration(
    //       //     color: status == "Online" ? Colors.green : Colors.blue,
    //       //     borderRadius: BorderRadius.circular(1),
    //       //   ),
    //       // ),
    //     ],
    //   ),
    // );
  }
}
