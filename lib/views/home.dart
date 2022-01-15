import 'package:chattingapp/helperfunctions/authenticate.dart';
import 'package:chattingapp/helperfunctions/sharedpref_helper.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/services/databse.dart';
import 'package:chattingapp/views/chatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "dart:core";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool issearching = false;
  String? myName, myProfilepic, myEmail;
  String myUserName = "";

  Stream? userStream, chatRoomStream;

  TextEditingController searchUsernameeditingcontroller =
      TextEditingController();

  getMyInfoFromSHaredPrefrences() async {
    myName = await SharedPreferncehelper().getDisplayName();
    myProfilepic = await SharedPreferncehelper().getProfileUrl();
    myUserName = (await SharedPreferncehelper().getUSerName())!;
    myEmail = await SharedPreferncehelper().getuseremail();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    onScreenloaded();
    setStatus("Online");
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

  getChatRoomIdByUserNames(String? a, String? b) {
    if (a!.compareTo(b!) == 1) {
      // a < b returns -1, 0 if equal, 1 if b<a
      // ignore: unnecessary_string_escapes
      return "$b\_$a";
    } else if (a.compareTo(b) == -1) {
      // ignore: unnecessary_string_escapes
      return "$a\_$b";
    }
  }

  onSearchBtnCLick() {
    issearching = true;
    userStream =
        DatabaseMethods().getUserByName(searchUsernameeditingcontroller.text);
    setState(() {});
  }

  Widget searchListUsertile({username, profileUrl, name, email}) {
    WidgetsFlutterBinding.ensureInitialized();
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          var chatroomid = getChatRoomIdByUserNames(myUserName, username);

          Map<String, dynamic> chatRoomInfoMap = {
            "users": [myUserName, username]
          };

          DatabaseMethods().createChatRoom(chatroomid, chatRoomInfoMap);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                username,
                name,
              ),
            ),
          );
        },
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Divider(
              color: Colors.black,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
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
                ),
                const SizedBox(
                  width: 8,
                ),
                const Divider(
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder searchUsersList() {
    //WidgetsFlutterBinding.ensureInitialized();
    return StreamBuilder<dynamic>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return searchListUsertile(
                      username: ds["username"],
                      profileUrl: ds["imgUrl"],
                      name: ds["name"],
                      email: ds["email"]);
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget chatRoomsList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, AsyncSnapshot snapshot) {
          // if (snapshot.connectionState != ConnectionState.done) {
          //   return const CircularProgressIndicator();
          // }
          if (snapshot.connectionState != ConnectionState.waiting) {
            return snapshot.hasData
                ? ListView.builder(
                    //always use shwrink wrap with streambuilder
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      // String imgurl =
                      //     snapshot.data.collection('chats').docs[0]['imgUrl'];

                      return ChatRoomListTile(
                          ds.id, ds["lastMessage"], myUserName);
                    })
                : const CircularProgressIndicator();
          } else {
            return const CircularProgressIndicator();
          }
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

  // bool showIgnIn = true;

  // void toggleView() {
  //   setState(() {
  //     showIgnIn = !showIgnIn;
  //   });
  // }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String inputData() {
    final User? user = auth.currentUser;
    //print(user!.providerData.toString());
    String provider = user!.providerData[0].providerId;
    return provider;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   inputData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenger Clone"),
        actions: [
          InkWell(
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
                            child: GestureDetector(
                              child: TextField(
                                controller: searchUsernameeditingcontroller,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "username"),
                                onSubmitted: (name) {
                                  onSearchBtnCLick();
                                },
                              ),
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
  String? name = '', username = '', status = '';
  var profilePicUrl = '';

  getThisUserInfo() async {
    username =
        widget.chatroomid.replaceAll(widget.mysername, "").replaceAll("_", "");
    QuerySnapshot<Object?> querySnapshot =
        await DatabaseMethods().getUserInfo(username);
    //  print(username);
    // print(widget.chatroomid);
    // print("a0");

    {
      name = await querySnapshot.docs[0]["name"];
      profilePicUrl = await querySnapshot.docs[0]["imgUrl"];
      status = await querySnapshot.docs[0]["status"];
    }

    setState(() {
      name = name;
      profilePicUrl = profilePicUrl;
      status = status;
      username = username;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    //_user
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  print(widget.imgurl);
    // String? _user = FirebaseAuth.instance.currentUser?.photoURL;
    // FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // return allChats(widget.lastmessage, widget.mysername, username!);
    return SingleChildScrollView(
      child: Column(
        children: [
          // const Divider(
          //   color: Colors.black,
          // ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(username!, name!),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                    profilePicUrl.isNotEmpty
                        ? profilePicUrl
                        : "https://www.global.hokudai.ac.jp/wp-content/uploads/2020/07/default-avatar-profile-image-vector-social-media-user-icon-potrait-182347582.jpg",
                    height: 30,
                    width: 30,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(height: 40, child: allChats()),
                    Text(
                      username!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(widget.lastmessage),
                  ],
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 7,
                  backgroundColor:
                      status == "Online" ? Colors.green : Colors.blue,
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),
          const Divider(
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
