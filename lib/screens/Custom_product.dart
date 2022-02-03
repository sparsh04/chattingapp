import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/screens/Cart_Screen.dart';
import 'package:my_kisan/screens/CustomCard.dart';
import 'package:my_kisan/screens/Maindrawer.dart';
import 'package:my_kisan/screens/notification_screen.dart';

class CustomProduct extends StatefulWidget {
  const CustomProduct({Key? key}) : super(key: key);

  @override
  State<CustomProduct> createState() => _CustomProductState();
}

class _CustomProductState extends State<CustomProduct> {
  var categorystream, notificationstream, wishliststream;
  FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getNotifications() async {
    notificationstream = await getuserNotifications();
    setState(() {});
  }

  getwishlist() async {
    this.wishliststream = await getuserwishlist();
    setState(() {});
  }

  doThisOnLaunch() async {
    await getNotifications();
    await getwishlist();
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

  Future<Stream<QuerySnapshot>> getuserwishlist() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.phoneNumber)
        .collection("Wishlist")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        child: MainDrawer(),
        backgroundColor: greencolor,
      ),
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: greencolor,
        centerTitle: true,
        title: Text("My Kisan"),
        leading: IconButton(
          onPressed: () {
            _scaffoldkey.currentState!.openDrawer();
          },
          icon: Image.asset(
            "assets/images/paragraph.png",
            color: Colors.white,
            width: 30,
          ),
        ),
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
      body: StreamBuilder(
        stream: wishliststream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> map =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  //print(map['price']);
                  return
                      //CustomBody(image: image, name: name, price: price, title: title, index: index, productid: productid)
                      CustomeProductCard(
                    image: map['imgurl'],
                    name: map['name'],
                    price: map['price'] ?? '',
                    title: map['category'],
                    index: index,
                    productid: map['productid'],
                    map: map,
                  );
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
