import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_kisan/screens/track_order.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var orderstream;

  List items = [
    {'name': 'Dosa', 'count': '2'},
    {'name': 'Paneer', 'count': '2'},
    {'name': 'Cake', 'count': '1'},
    {'name': 'Dosa', 'count': '4'}
  ];

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getcart();
  }

  getcart() async {
    this.orderstream = await getuserorders();
    setState(() {});
  }

  Future<Stream<QuerySnapshot>> getuserorders() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.phoneNumber)
        .collection("orders")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: orderstream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        final now = map['ts'].toDate();
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        final String formatted = formatter.format(now);
                        final String formattedTime =
                            DateFormat.Hms().format(now);
                        return Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Container(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Color(0xfffe0c00d),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: Text('Rolex Hotel',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          Spacer(),
                                          Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: Text(
                                                  formatted +
                                                      "  " +
                                                      formattedTime,
                                                  //'${DateTime.parse(map['ts'].toDate().toString())}',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ],
                                      ),
                                      //    SizedBox(height: 10),

                                      //    children: map['orderlist']
                                      //   .list((e) =>
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        height: 50,
                                        // width: 10,
                                        width: double.infinity,
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            childAspectRatio: 0.3,
                                            mainAxisSpacing: 5.0,
                                            //  crossAxisSpacing: 100.0,
                                          ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: map['orderlist'].length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              // decoration: BoxDecoration(
                                              //     color: Colors.black),
                                              alignment: Alignment.topLeft,
                                              //  height: 100,
                                              //    width: 100,
                                              child: Chip(
                                                label: Text(
                                                    map['orderlist'][index],
                                                    // '${e['name']}  X ${e['count']}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                              ),
                                            );
                                            ;
                                          },
                                        ),
                                      ),

                                      //)
                                      //   .toList(),

                                      SizedBox(height: 10),
                                      Row(children: [
                                        Text(
                                          "Total:",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "₹" + ' ${map['amount']}',
                                        )
                                      ]),
                                      SizedBox(height: 20),
                                      Row(children: [
                                        Flexible(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TrackOrder()));
                                            },
                                            child: Container(
                                                // width:
                                                //     MediaQuery.of(context)
                                                //             .size
                                                //             .width *
                                                //         0.35,
                                                height: 42,
                                                child: Center(
                                                    child: Text(
                                                  "Track order",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                )),
                                                decoration: BoxDecoration(
                                                    color: Color(0xfffe0c00d),
                                                    border: Border.all(
                                                      color: Color(0xfffe0c00d),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5)))),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Flexible(
                                          flex: 3,
                                          child: GestureDetector(
                                            child: Container(
                                                // width:
                                                //     MediaQuery.of(context)
                                                //             .size
                                                //             .width *
                                                //         0.4,
                                                height: 42,
                                                child: Center(
                                                    child: Text(
                                                  "Cancel Order",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xfffe0c00d),
                                                  ),
                                                )),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Color(0xfffe0c00d),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5)))),
                                          ),
                                        )
                                      ])
                                    ]),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
