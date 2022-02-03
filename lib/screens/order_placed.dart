import 'package:flutter/material.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/size_config.dart';

class OrderPalced extends StatefulWidget {
  const OrderPalced({Key? key}) : super(key: key);

  @override
  _OrderPalcedState createState() => _OrderPalcedState();
}

class _OrderPalcedState extends State<OrderPalced> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Placed"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 120,
            ),
            child: Text("Congratulation!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Image.asset("assets/images/ok.png")),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text("Your Order placed",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
            ),
            child: MaterialButton(
              height: screenHeight(context) / 22,
              minWidth: screenHeight(context) * 0.2,
              onPressed: () {},
              color: Color(0xfffeda704),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Go Back",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 50),
          //   height: 80,
          //   width: double.infinity,
          //   decoration: BoxDecoration(color: whitecolors, boxShadow: [
          //     BoxShadow(
          //         offset: Offset(0, 10),
          //         blurRadius: 33,
          //         color: Color(0xffd3d3d3).withOpacity(.90))
          //   ]),
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 10, right: 20),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         // Padding(
          //         //   padding: const EdgeInsets.only(top: 30),
          //         //   child: Column(
          //         //     children: [
          //         //       Text("1 Item| ₹ 310",
          //         //           style: TextStyle(
          //         //               fontSize: 18, fontWeight: FontWeight.w500)),
          //         //       Text(
          //         //         "Extra charges may apply",
          //         //         style: TextStyle(color: Colors.grey),
          //         //       )
          //         //     ],
          //         //   ),
          //         // ),
          //         // MaterialButton(
          //         //   height: screenHeight(context) / 22,
          //         //   minWidth: screenWidth(context) * 0.3,
          //         //   onPressed: () {},
          //         //   color: Color(0xfffeda704),
          //         //   shape: RoundedRectangleBorder(
          //         //       borderRadius: BorderRadius.circular(10)),
          //         //   child: Text(
          //         //     "CheckOut",
          //         //     style: TextStyle(color: Colors.white, fontSize: 16),
          //         //   ),
          //         // ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
