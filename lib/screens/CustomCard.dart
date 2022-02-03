import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/size_config.dart';

class CustomeProductCard extends StatefulWidget {
  String? image;
  String? name;
  var price;
  String? title;
  int? index;
  String? productid;
  var map;

  CustomeProductCard({
    required this.image,
    required this.name,
    required this.price,
    required this.title,
    required this.index,
    required this.productid,
    required this.map,
  });

  @override
  State<CustomeProductCard> createState() => _CustomeProductCardState();
}

class _CustomeProductCardState extends State<CustomeProductCard> {
  var isLoading = false;
  var index0 = 0;
  var wishliststream;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  getwishlist() async {
    setState(() {
      widget.image = widget.image;
      widget.index = widget.index;
      widget.map = widget.map;
      widget.name = widget.name;
      widget.price = widget.price;
      widget.productid = widget.productid;
      widget.title = widget.title;
    });
  }

  Future removefromwishlist() async {
    setState(() {});
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.phoneNumber)
        .collection('Wishlist')
        .doc(widget.productid)
        .delete();
  }

  addtocard() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.phoneNumber)
        .collection('cart')
        .doc(widget.productid)
        .get();

    widget.map['quantity'] = 1;

    if (snapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product Already in your Cart")));
    } else {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.phoneNumber)
          .collection('cart')
          .doc(widget.productid)
          .set(widget.map);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Product Added to Cart")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    widget.price = widget.price;
    index0 = widget.index!;
    getwishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      height: Height / 6,
      width: double.infinity,
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 33,
                color: Color(0xffd3d3d3).withOpacity(0.90))
          ]),
      child: StreamBuilder<Object>(
          stream: wishliststream,
          builder: (context, snapshot) {
            return Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(widget.image as String),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: -10,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset("assets/images/nonveg.png"),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 3,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        widget.name as String,
                        style: headingstyle(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.title as String,
                        style: subheadingstyle(),
                      ),
                      Spacer(),
                      Text(
                        '${widget.price}',
                        style: headingstyle(),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 35),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          removefromwishlist();
                          setState(() {});
                        },
                        child: Container(
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          addtocard();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 25),
                          height: Height / 25,
                          width: Width / 5,
                          decoration: BoxDecoration(
                              color: Color(0xfffe0c00d),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "Add",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
