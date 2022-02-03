import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/screens/Cart_Screen.dart';
import 'package:my_kisan/screens/order_placed.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  int total;
  var items;
  PaymentScreen({required this.total, this.items});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    getuser();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_Mqukymbnx3hIYA",
      "amount": widget.total * 100,
      "name": "CFJ-Ulrapi App",
      "description": "Payment for items ordered",
      "prefill": {"contact": FirebaseAuth.instance.currentUser!.phoneNumber},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void addorders() async {
    String v = randomString(10);

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("orders")
        .doc(v)
        .set({
      "orderlist": widget.items,
      "ts": DateTime.now(),
      "mode": "Online",
      "amount": widget.total,
    });
    ;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OrderPalced()));
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Payment successfull")));
    addorders();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Payment Failed")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("External Wallet selected")));
  }

  Future<dynamic> getuser() async {
    final userdoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .get();

    final userdata = userdoc.data();
    print(userdata);
    return userdata;
  }

  var _result;
  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                    activeColor: orangecolor,
                    value: '0',
                    groupValue: _result,
                    onChanged: (value) {
                      setState(() {
                        _result = value;
                        print(_result);
                      });
                    }),
                Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Radio(
                    activeColor: orangecolor,
                    value: '1',
                    groupValue: _result,
                    onChanged: (value) {
                      setState(() {
                        _result = value;
                        print(_result);
                      });
                    }),
                Text(
                  "Cash on Delivery",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Radio(
                    activeColor: orangecolor,
                    value: '2',
                    groupValue: _result,
                    onChanged: (value) {
                      setState(() {
                        _result = value;
                      });
                    }),
                Text(
                  "Wallet",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PaymentDetail(
                prodDiscount: '₹310.00',
                totalAmt: '₹00.00',
                totalMrp: '₹310.00',
                total: widget.total,
              ),
            ),
            Spacer(),
            MaterialButton(
              height: Height / 22,
              minWidth: Width * 0.8,
              onPressed: () async {
                if (_result.toString() == "1") {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OrderPalced()));
                  String v = randomString(10);

                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                      .collection("orders")
                      .doc(v)
                      .set({
                    "orderlist": widget.items,
                    "ts": DateTime.now(),
                    "mode": "COD",
                    "amount": widget.total,
                  });
                  ;
                }

                if (_result.toString() == "0") {
                  openCheckout();
                }

                if (_result.toString() == "2") {
                  var data = await getuser();
                  var wallettotal = data['wallettotal'].toInt();
                  var total = widget.total.toInt();
                  print((wallettotal));
                  print((total));
                  if ((wallettotal) >= (total)) {
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    final String formatted = formatter.format(now);
                    final String formattedTime = DateFormat.Hms().format(now);
                    Map<String, dynamic> userInfoMap = {
                      "amount": widget.total,
                      "time": formattedTime,
                      "date": formatted,
                      "type": "Purchase",
                      "ts": DateTime.now(),
                    };

                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                        .collection("wallet")
                        .doc(randomString(10))
                        .set(userInfoMap);

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                        .update({"wallettotal": wallettotal - total.toInt()});

                    String v = randomString(10);
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                        .collection("orders")
                        .doc(v)
                        .set({
                      "orderlist": widget.items,
                      "ts": DateTime.now(),
                      "mode": "Wallet",
                      "amount": widget.total,
                    });
                    ;

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => OrderPalced()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Wallet Balance Not Enough")));
                  }
                }
              },
              color: Color(0xfffeda704),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
