import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_kisan/Component/bottom_bar.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/screens/Categaory_product.dart';
import 'package:my_kisan/screens/Custom_product.dart';
import 'package:my_kisan/screens/Login_Screen.dart';
import 'package:my_kisan/screens/home_screen.dart';
import 'package:my_kisan/screens/order_placed.dart';
import 'package:my_kisan/screens/orders.dart';
import 'package:my_kisan/screens/payment_screen.dart';
import 'package:my_kisan/screens/profile_screen.dart';
import 'package:my_kisan/screens/wallet.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  // color: Color(0xFF40D876)
                  ),
              accountName: Row(
                children: [
                  new Text(
                    _auth.currentUser!.displayName as String,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              accountEmail: new Text(
                _auth.currentUser!.phoneNumber as String,
                style: new TextStyle(fontSize: 16.0),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(_auth.currentUser!.photoURL as String),
              ),
              otherAccountsPictures: <Widget>[],
            ),
          ],
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => BottomBar(0)));
        },
        leading: Icon(
          Icons.home,
          size: 24,
          color: Colors.white,
        ),
        title: Text(
          "Home",
          style: new TextStyle(fontSize: 16.0, color: whitecolors),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => BottomBar(1)));
        },
        leading: Icon(
          Icons.dashboard,
          color: Colors.white,
        ),
        title: Text(
          "Categories",
          style: new TextStyle(fontSize: 16.0, color: whitecolors),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => BottomBar(3)));
        },
        leading: Icon(
          Icons.favorite_border,
          size: 24,
          color: Colors.white,
        ),
        title: Text(
          "Whislist",
          style: new TextStyle(fontSize: 16.0, color: whitecolors),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Orders()));
        },
        leading: Icon(
          Icons.card_travel,
          size: 24,
          color: Colors.white,
        ),
        title: Text(
          "Order",
          style: new TextStyle(fontSize: 16.0, color: whitecolors),
        ),
      ),
      ListTile(
        onTap: () {
          // Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyWallet()));
          //  Navigator.pushNamed(context, MyWallet.routName);
        },
        leading: Icon(
          Icons.account_balance_wallet_rounded,
          size: 24,
          color: Colors.white,
        ),
        title: Text(
          "Wallet",
          style: new TextStyle(fontSize: 16.0, color: whitecolors),
        ),
      ),
      // ListTile(
      //   onTap: () {
      //     Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (context) => ProfileScreen()));
      //   },
      //   leading: Icon(
      //     Icons.person,
      //     size: 30,
      //     color: Colors.white,
      //   ),
      //   title: Text(
      //     "Profile",
      //     style: new TextStyle(fontSize: 16.0, color: whitecolors),
      //   ),
      // ),
      ListTile(
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        leading: Icon(
          Icons.power_settings_new,
          size: 24,
          color: Colors.white,
        ),
        title: Text(
          "Logout",
          style: new TextStyle(fontSize: 16.0, color: whitecolors),
        ),
      ),
    ]);
  }
}
