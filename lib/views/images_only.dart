import 'package:chattingapp/services/databse.dart';
import 'package:chattingapp/views/chatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "dart:core";

class Imagesonly extends StatefulWidget {
  //const Imagesonly({ Key? key }) : super(key: key);
  final String chatRoomId;

  // ignore: use_key_in_widget_constructors
  const Imagesonly(this.chatRoomId);

  @override
  _ImagesonlyState createState() => _ImagesonlyState();
}

class _ImagesonlyState extends State<Imagesonly> {
  Widget chatMessages() {
    return StreamBuilder(
        stream: imagestream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot? ds = snapshot.data.docs[index];
                  Map<String, dynamic> map =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  DateTime dt = (ds!['ts'] as Timestamp).toDate();
                  DateFormat formatter = DateFormat('yyyy-MM-dd');
                  String formatted = formatter.format(dt);
                  String time = DateFormat.Hms().format(dt);
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ShowImage(
                          imageUrl: map['message'],
                        ),
                      ),
                    ),
                    child: Card(
                      shadowColor: Colors.black,
                      elevation: 10,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            ds["message"],
                            fit: BoxFit.cover,
                          ),
                          Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            elevation: 16,
                                            child: SizedBox(
                                              height: 250,
                                              // decoration: BoxDecoration(
                                              //   border: Border.all(),
                                              // ),
                                              child: Column(
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(Icons.info),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Details",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  // const Divider(
                                                  //   color: Colors.black,
                                                  // ),
                                                  Container(
                                                    // margin: EdgeInsets.all(20),
                                                    margin: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: Column(
                                                      children: [
                                                        // const SizedBox(height: 20),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons.summarize,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              ds["size"] + "Kb",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // const Divider(
                                                  //   color: Colors.black,
                                                  // ),

                                                  const SizedBox(
                                                    height: 22,
                                                  ),
                                                  Container(
                                                    // margin: EdgeInsets.all(20),
                                                    margin: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .calendar_today,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              formatted,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                                height: 30),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 22,
                                                  ),
                                                  Container(
                                                    // margin: EdgeInsets.all(20),
                                                    margin: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.lock_clock,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              time,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                                height: 30),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // const Divider(
                                                  //   color: Colors.black,
                                                  // ),
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.info,
                                    color: Colors.red,
                                  ))),
                          // Container(
                          //   alignment: Alignment.bottomCenter,
                          //   child: Container(
                          //     color: Colors.black.withOpacity(0.8),
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 8, vertical: 8),
                          //     child: Row(
                          //       children: [
                          //         Text(
                          //           "hello",
                          //           style: TextStyle(color: Colors.white),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  // ignore: prefer_typing_uninitialized_variables
  var imagestream;

  getandsetMessages() async {
    //messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    imagestream = await DatabaseMethods().getChatRoomImages(widget.chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getandsetMessages();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
      ),
      body: Container(child: chatMessages()),
    );
  }
}
