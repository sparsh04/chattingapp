import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_kisan/Component/category_roundcard.dart';
import 'package:my_kisan/accessories/Position.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/screens/Cart_Screen.dart';
import 'package:my_kisan/screens/Maindrawer.dart';
import 'package:my_kisan/screens/notification_screen.dart';
import "dart:core";

class CategoryProduct extends StatefulWidget {
  const CategoryProduct({Key? key}) : super(key: key);

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  var categorystream, notificationstream, position, location, address;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getCcategories() async {
    return FirebaseFirestore.instance.collection("Category").snapshots();
  }

  getcategories() async {
    categorystream = await getCcategories();
    setState(() {});
  }

  getNotifications() async {
    //messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    notificationstream = await getuserNotifications();
    setState(() {});
  }

  getlocation() async {
    position = await Locationa().determinePosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);
    setState(() {});
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemark[0];
    address = '${place.administrativeArea},${place.subAdministrativeArea}';
    setState(() {});
  }

  doThisOnLaunch() async {
    await getlocation();
    await getcategories();
    await getNotifications();
  }

  @override
  void initState() {
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
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      drawer: Drawer(
        child: MainDrawer(),
        backgroundColor: greencolor,
      ),
      appBar: AppBar(
        //   automaticallyImplyLeading: false,
        backgroundColor: greencolor,
        title: Text("Category"),
        centerTitle: true,
        actions: [
          StreamBuilder(
              stream: notificationstream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                {
                  return IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, NotificationScreen.routName);
                      },
                      icon: Badge(
                          badgeContent: Text(
                            snapshot.hasData
                                ? '${snapshot.data!.docs.length}'
                                : "0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          child: Icon(
                            Icons.notifications,
                            size: 25,
                          )));
                }
              }),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routName);
              },
              icon: Badge(
                  badgeContent: Text(
                    "2",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 25,
                  ))),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15, left: 10),
              height: Height / 20,
              //  width: Width * 0.4 - 10,
              decoration: BoxDecoration(
                color: whitecolors,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 10),
                      height: Height / 20,
                      // width: Width * 0.4 - 10,
                      decoration: BoxDecoration(
                        color: whitecolors,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            "assets/images/location.png",
                            width: 25,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  '${address}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              55),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: StreamBuilder(
            stream: categorystream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    // DocumentSnapshot? ds = snapshot.data.docs[index];
                    Map<String, dynamic> map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    print(map['Name']);
                    return GestureDetector(
                      onTap: () {},
                      child: CategoryRoundCard(
                          image: map["Imgurl"], name: map["Name"]),
                      // child: Container(

                      //     child: Text(map['Name'])),
                    );
                  },
                );
              } else {
                return Center(
                    child: Container(
                        height: 40, child: const CircularProgressIndicator()));
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [],
        ),
      ]),
    );
  }
}
