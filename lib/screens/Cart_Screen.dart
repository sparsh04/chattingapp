import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/screens/payment_screen.dart';
//import ;'package:my_kisan/screens/rajorpayscreen.dart'
//import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartScreen extends StatefulWidget {
  static String routName = "/cart_screen";
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int total = 0;
  var items;
  var cartstream;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    getcart();
    super.initState();
  }

  //

  FirebaseAuth _auth = FirebaseAuth.instance;

  getcart() async {
    this.cartstream = await getusercart();
    int temp = await getTotal();
    // int temp = await getTotal();
    // int temp = await getTotal();
    List tempitems = await getallitems();
    setState(() {
      total = temp;
      items = tempitems;
    });
  }

  addquantity(String productid, int quantity) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.phoneNumber)
        .collection("cart")
        .doc(productid)
        .update({"quantity": quantity + 1});

    int temp = await getTotal();
    List tempitems = await getallitems();
    setState(() {
      total = temp;
      items = tempitems;
    });
  }

  minusquantity(String productid, int quantity) async {
    if (quantity > 1) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.phoneNumber)
          .collection("cart")
          .doc(productid)
          .update({"quantity": quantity - 1});
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.phoneNumber)
          .collection("cart")
          .doc(productid)
          .delete();
    }

    int temp = await getTotal();
    List tempitems = await getallitems();
    setState(() {
      total = temp;
      items = tempitems;
    });
  }

  Future<Stream<QuerySnapshot>> getusercart() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.phoneNumber)
        .collection("cart")
        .snapshots();
  }

  Future<int> getTotal() async {
    int total = 0;
    int totalitems = 0;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.phoneNumber)
        .collection('cart')
        .get()
        .then((value) {
      List<DocumentSnapshot> ls = value.docs;
      // print(ls[0].toString());
      ls.forEach((element) {
        print(element['price'] + element['quantity']);
        int price = element['price'] as int;
        int quantity = element['quantity'] as int;

        totalitems += quantity;
        total += (price * quantity);
        // print(total);
      });
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.phoneNumber)
        .update({"carttotal": total, "totalitems": totalitems});
    //setState(() {});
    //print("total:$total");
    return total;
  }

  Future<List> getallitems() async {
    List items = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.phoneNumber)
        .collection('cart')
        .get()
        .then((value) {
      List<DocumentSnapshot> ls = value.docs;
      ls.forEach((element) {
        String name = element['name'];
        int quantity = element['quantity'];
        var a = name + " x " + '${quantity}';
        items.add(a);
        // items.add(a);
      });
    });

    print(items);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: greencolor,
          title: Text("Cart"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                StreamBuilder(
                    stream: cartstream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return Container(
                          alignment: Alignment.center,
                          height: snapshot.data!.docs.length * 80.00,
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> map =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;

                              // total = total + map['quantity'] * map['price'];
                              return Container(
                                padding: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.center,
                                // decoration: BoxDecoration(
                                //   border: Border.all(color: Colors.black),
                                // ),
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Image.asset(
                                          'assets/images/nonveg.png'),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 30, left: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(map['name'],
                                              style: TextStyle(fontSize: 18)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("in " + map['category'],
                                              style: subheadingstyle()),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      // padding: EdgeInsets.only(
                                      //     left: 5, right: 5, top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                          color: orangecolor.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              addquantity(map['productid'],
                                                  map['quantity']);
                                            },
                                            child: Icon(
                                              Icons.add_circle,
                                              color: orangecolor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${map['quantity']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              minusquantity(map['productid'],
                                                  map['quantity']);
                                            },
                                            child: Icon(Icons.remove_circle,
                                                color: orangecolor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "₹" +
                                              '${map['quantity'] * map['price']}',
                                          style: headingstyle(),
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else
                        return Container();
                    }),
                SizedBox(
                  height: 10,
                ),
                ExpandableNotifier(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 180),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        ScrollOnExpand(
                          scrollOnExpand: true,
                          scrollOnCollapse: false,
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              iconColor: Colors.black,
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                            ),
                            header: InkWell(
                              onTap: () {},
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(),
                                        Text(
                                          "Customize",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            collapsed: Container(),
                            expanded: InkWell(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                height: 25,
                                width: 100,
                                margin: EdgeInsets.only(left: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: orangecolor,
                                    )),
                                child: Text(
                                  "Add new Item",
                                  style: TextStyle(color: orangecolor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                SizedBox(
                  height: 30,
                ),
                PaymentDetail(
                  prodDiscount: '₹' + '${'total'}',
                  totalAmt: '₹00.00',
                  totalMrp: '₹310.00',
                  total: total,
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Any request for the resturant",
                            style: TextStyle(color: Colors.grey[600]),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            height: 35,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(color: orangecolor),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Coupan code",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: MaterialButton(
                              height: Height / 25,
                              minWidth: Width * 0.4 - 20,
                              onPressed: () {},
                              color: Color(0xfffeda704),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Address",
                                style: TextStyle(
                                    color: textcolorblack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Column(
                              children: [
                                Text(
                                  "CHANGE",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 2,
                        indent: 300,
                        endIndent: 30,
                      ),
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("201,Karvali Road Bhiwandi"))
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: MaterialButton(
                          height: Height / 22,
                          minWidth: Width * 0.8,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PaymentScreen(total: total, items: items)));
                          },
                          color: Color(0xfffeda704),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Make Payment",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentDetail extends StatelessWidget {
  const PaymentDetail({
    Key? key,
    required this.totalMrp,
    required this.prodDiscount,
    required this.totalAmt,
    required this.total,
  }) : super(key: key);
  final String totalMrp;
  final String prodDiscount;
  final String totalAmt;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Payment Detail",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Total M.R.P",
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    '₹' + '${total}',
                    style: TextStyle(
                        color: textcolorblack,
                        // fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ],
          ),
          Divider(
            thickness: 1,
            endIndent: 0,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Product Discount",
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "₹ 00.00",
                    style: TextStyle(
                        color: textcolorblack,
                        // fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ],
          ),
          Divider(
            thickness: 1,
            endIndent: 25,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                        color: textcolorblack, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    '₹' + '${total}',
                    style: TextStyle(
                        color: textcolorblack,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "You Save ₹ 371.00",
                    style: TextStyle(
                      color: greencolor,
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
